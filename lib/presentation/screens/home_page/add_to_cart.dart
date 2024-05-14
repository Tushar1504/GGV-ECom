import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ggv_ecom/data/models/cart_model.dart';
import 'package:ggv_ecom/presentation/common_widgets/common_button/common_button.dart';
import 'package:ggv_ecom/presentation/screens/home_page/oder_history.dart';
import 'package:ggv_ecom/presentation/screens/home_page/payment_screen.dart';

import '../../blocs/add_to_cart/add_to_cart_bloc.dart';

class AddToCartScreen extends StatelessWidget {
  const AddToCartScreen({Key? key}) : super(key: key);

  double _calculateTotalPrice(List<CartItemModel> cartItems, OfferState? offerState) {
    double totalPrice = 0.0;
    for (var item in cartItems) {
      if (item.isSelected) {
        double amountWithGST = item.amount * 1.18;
        double discountedAmount = offerState != null ? _calculateDiscountedAmount(amountWithGST, offerState) : amountWithGST;
        totalPrice += item.quantity * discountedAmount;
      }
    }
    return totalPrice;
  }

  double _calculateDiscountedAmount(double amount, OfferState offerState) {
    if (offerState is SBIState) {
      return amount * (1 - offerState.discountPercentage);
    } else if (offerState is AxisState) {
      return amount * (1 - offerState.discountPercentage);
    } else if (offerState is FirstTransactionState) {
      return amount * (1 - offerState.discountPercentage);
    } else {
      return amount;
    }
  }

  @override
  Widget build(BuildContext context) {
    final addToCartBloc = BlocProvider.of<AddToCartBloc>(context);
    addToCartBloc.add(AddToCartInitialEvent());
    return Scaffold(
      appBar: AppBar(title: const Text("Add to Cart")),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: BlocBuilder<AddToCartBloc, AddToCartState>(
          builder: (context, state) {
            if (state is AddToCartItemAddedSuccessState) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: state.cartItems.length,
                      itemBuilder: (context, index) {
                        final cartItem = state.cartItems[index];
                        return Card(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Checkbox(
                                      value: cartItem.isSelected,
                                      onChanged: (bool? value) {
                                        addToCartBloc.add(
                                          CheckedItemsInCartEvent(
                                            checkedItems: state.cartItems,
                                            onClick: value!,
                                            index: index,
                                          ),
                                        );
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 5),
                                          Text(
                                            "Product : ${cartItem.product}",
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Text("Desc: ${cartItem.description}"),
                                          Text("₹ ${cartItem.amount.toStringAsFixed(2)}"),
                                          Text('(Inclusive of all taxes with 18% GST)'),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                  onTap: (){
                                                    addToCartBloc.add(
                                                      OnMinusButtonEvent(
                                                        cartList: state.cartItems,
                                                        index: index,
                                                        quantity: cartItem.quantity,
                                                        totalPrice: cartItem.amount,
                                                      ),
                                                    );
                                                  },
                                                  child: Icon(Icons.remove)),

                                              SizedBox(width: 8,),
                                              Text(cartItem.quantity.toString()),
                                              SizedBox(width: 8,),
                                              GestureDetector(
                                                onTap: () {
                                                  addToCartBloc.add(
                                                    OnAddButtonEvent(
                                                      cartList: state.cartItems,
                                                      index: index,
                                                      quantity: cartItem.quantity,
                                                      totalPrice: cartItem.amount,
                                                    ),
                                                  );
                                                },
                                                child: Icon(Icons.add),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          const Row(
                                            children: [
                                              Icon(Icons.local_offer_outlined, color: Colors.black,),
                                              SizedBox(width: 5,),
                                              Text('Offers', style: TextStyle(fontWeight: FontWeight.w600),),
                                            ],
                                          ),
                                          ElevatedButton(onPressed: (){
                                            addToCartBloc.add(SelectSBIEvent(index));
                                          }, child: Text('3% Discount on SBI credit card')),
                                          ElevatedButton(onPressed: (){
                                            addToCartBloc.add(SelectAxisEvent(index));
                                          }, child: Text('5% Discount on Axis credit card')),
                                          ElevatedButton(onPressed: (){
                                            addToCartBloc.add(SelectFirstTransactionEvent(index));
                                          }, child: Text('Flat 2% off on first transaction'))
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (cartItem.id != null) {
                                          addToCartBloc.add(RemoveProductFromCartEvent(cartItem.id!));
                                        }
                                      },
                                      child: const Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Total Price: ₹ ${_calculateTotalPrice(state.cartItems, state.offerState).toStringAsFixed(2)}  (Inclusive of all taxes)',
                      ),

                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderHistoryScreen(),
                        ),
                      ).then((value) {
                        addToCartBloc.add(AddToCartInitialEvent());
                      });
                      addToCartBloc.add(PlaceOrderEvent());
                    },
                    child: const Text('Continue'),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
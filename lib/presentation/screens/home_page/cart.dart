import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ggv_ecom/data/data_sources/remote/sqlite.dart';
import 'package:ggv_ecom/data/models/cart_model.dart';
import 'package:ggv_ecom/presentation/blocs/cart_bloc/cart_bloc.dart';
import 'package:ggv_ecom/presentation/blocs/logged_out/logged_out_bloc.dart';
import 'package:ggv_ecom/presentation/screens/home_page/add_to_cart.dart';
import 'package:ggv_ecom/presentation/screens/home_page/oder_history.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../core/constants/my_colors.dart';
import '../../common_widgets/common_button/common_button.dart';
import '../../common_widgets/common_button/common_text_field.dart';

@routePage
class HomePage extends StatelessWidget {
  HomePage({super.key});

  final searchController = TextEditingController();
  final dataBaseHelper = DataBaseHelper();
  final productController = TextEditingController();
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CartBloc cartBloc = CartBloc(dataBaseHelper: dataBaseHelper)
      ..add(FetchCartItemEvent());
    return Scaffold(
      appBar: AppBar(
        title: const Text("DivineMart"),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => OrderHistoryScreen()));
          }, icon: Icon(Icons.history, color: Colors.black,)),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AddToCartScreen()));
            },
            child: const Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              BlocProvider.of<LoggedOutBloc>(context).add(UserRequestedLogout(context));
            },
            child: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (query) {
                    _filterItems(context, query, cartBloc);
                  },
                ),
              ),
              BlocBuilder<CartBloc, CartState>(
                bloc: cartBloc,
                builder: (context, state) {
                  if (state is CartScreenLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CartScreenLoadedState) {
                    final items = state.cartItems;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return _buildItemCard(context, items[index], dataBaseHelper, cartBloc);
                      },
                    );
                  } else {
                    return const Center(child: Text('No items found.'));
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.primaryColor,
        child: const Icon(Icons.add),
        onPressed: () {
          _showAddProductDialog(context, dataBaseHelper, cartBloc);
        },
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, CartModel item, DataBaseHelper dataBaseHelper, CartBloc cartBloc) {
    return Card(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "${item.product}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("Desc: ${item.description}"),
                Text("₹ ${item.amount.toString()}"),
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  cartBloc.add(CartItemDeleteEvent(item.id!));
                },
                child: const Icon(Icons.delete),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  _showEditProductDialog(context, item, cartBloc);
                },
                child: const Icon(Icons.edit),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  final cartItem = CartItemModel(
                    id: item.id ?? 0,
                    product: item.product,
                    description: item.description,
                    amount: item.amount,
                    quantity: 1,
                    isSelected: true,
                  );
                  BlocProvider.of<CartBloc>(context).add(CartItemAddedOnClickedEvent(clickedItem: cartItem));
                },
                child: const Icon(Icons.shopping_cart),
              ),
              const SizedBox(width: 8),
            ],
          )
        ],
      ),
    );
  }

  void _filterItems(BuildContext context, String query, CartBloc cartBloc) {
    if (query.isEmpty) {
      cartBloc.add(FetchCartItemEvent());
    } else {
      cartBloc.add(CartItemSearchEvent(query));
    }
  }

  void _showAddProductDialog(BuildContext context, DataBaseHelper dataBaseHelper, CartBloc cartBloc) async {
    await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text("Add a New Product"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: productController, decoration: const InputDecoration(hintText: "Product")),
                TextField(controller: descriptionController, decoration: const InputDecoration(hintText: "Description")),
                TextField(controller: amountController, decoration: const InputDecoration(hintText: "Amount")),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final newItem = CartModel(
                    product: productController.text,
                    description: descriptionController.text,
                    amount: double.tryParse(amountController.text) ?? 0.0,
                  );
                  productController.clear();
                  descriptionController.clear();
                  amountController.clear();
                  cartBloc.add(AddCartItemEvent(items: newItem));
                  Navigator.pop(context);
                },
                child: const Text("Add"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
            ],
          ),
    );
  }

  void _showEditProductDialog(BuildContext context, CartModel item, CartBloc cartBloc) async {
    await showDialog(
      context: context,
      builder: (context) => EditProductDialog(item: item, cartBloc: cartBloc),
    );
  }
}

class EditProductDialog extends StatelessWidget {
  final CartModel item;
  final CartBloc cartBloc;

  const EditProductDialog({required this.item, required this.cartBloc});

  @override
  Widget build(BuildContext context) {
    final TextEditingController productController = TextEditingController(text: item.product);
    final TextEditingController descriptionController = TextEditingController(text: item.description);
    final TextEditingController amountController = TextEditingController(text: item.amount.toString());

    return AlertDialog(
      title: const Text("Edit Product"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: productController, decoration: const InputDecoration(hintText: "Product"), maxLines: null),
          TextField(controller: descriptionController, decoration: const InputDecoration(hintText: "Description"), maxLines: null),
          TextField(controller: amountController, decoration: const InputDecoration(hintText: "Amount"), maxLines: null),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            final updatedItem = CartModel(
              id: item.id,
              product: productController.text,
              description: descriptionController.text,
              amount: double.tryParse(amountController.text) ?? 0.0,
            );
            cartBloc.add(
              CartItemUpdateEvent(
                id: item.id!,
                product: updatedItem.product,
                description: updatedItem.description,
                amount: updatedItem.amount,
              ),
            );
            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}

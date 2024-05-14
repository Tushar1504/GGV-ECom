import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../../data/data_sources/remote/sqlite.dart';
import '../../../data/models/cart_model.dart';

part 'add_to_cart_event.dart';
part 'add_to_cart_state.dart';

class AddToCartBloc extends Bloc<AddToCartEvent, AddToCartState> {
  final DataBaseHelper _dataBaseHelper;
  AddToCartBloc({required DataBaseHelper dataBaseHelper})
      : _dataBaseHelper = dataBaseHelper,
        super(AddToCartInitial()) {
    on<AddToCartInitialEvent>((event, emit) async {
      emit(AddToCartLoadingState());
      try {
        final item = await _dataBaseHelper.getAddToCartItems();
        emit(AddToCartItemAddedSuccessState(cartItems: item, offerState: null));
        print("$item");
      } catch (e) {
        emit(AddToCartErrorState("Oops Something went wrong!!!"));
      }
    });

    on<RemoveProductFromCartEvent>((event, emit) async {
      emit(AddToCartLoadingState());
      try {
        final id = await _dataBaseHelper.removeFromCart(event.id);
        final item = await _dataBaseHelper.getAddToCartItems();

        emit(ItemRemovedFromCartState(id));
        emit(AddToCartItemAddedSuccessState(cartItems: item, offerState: null));
      } catch (e) {
        emit(AddToCartErrorState("Oops Something went wrong!!!"));
      }
    });

    on<CheckedItemsInCartEvent>((event, emit) {
      event.checkedItems[event.index!].isSelected = !event.checkedItems[event.index!].isSelected;
      emit(AddToCartItemAddedSuccessState(cartItems: event.checkedItems));
    });


    // Updated on<OnAddButtonEvent> and on<OnMinusButtonEvent> handlers

    on<OnAddButtonEvent>((event, emit) {
      event.quantity = event.quantity! + 1;
      event.cartList[event.index!].quantity = event.quantity!;
      double newTotalPrice = event.cartList.fold(0.0, (total, item) => total + (item.quantity * item.amount));
      event.cartList.first.totalPrice = newTotalPrice;
      emit(AddToCartItemAddedSuccessState(cartItems: event.cartList));
    });

    on<OnMinusButtonEvent>((event, emit) {
      if (event.quantity! > 1) {
        event.quantity = event.quantity! - 1;
        event.cartList[event.index!].quantity = event.quantity!;
        double newTotalPrice = event.cartList.fold(0.0, (total, item) => total + (item.quantity * item.amount));
        event.cartList.first.totalPrice = newTotalPrice;
        emit(AddToCartItemAddedSuccessState(cartItems: event.cartList));
      }
    });


    on<SelectSBIEvent>((event, emit) {
      final currentState = state;
      if (currentState is AddToCartItemAddedSuccessState) {
        emit(AddToCartItemAddedSuccessState(
          cartItems: currentState.cartItems,
          offerState: SBIState(),
        ));
      }
    });

    on<SelectAxisEvent>((event, emit) {
      final currentState = state;
      if (currentState is AddToCartItemAddedSuccessState) {
        emit(AddToCartItemAddedSuccessState(
          cartItems: currentState.cartItems,
          offerState: AxisState(),
        ));
      }
    });

    on<SelectFirstTransactionEvent>((event, emit) {
      final currentState = state;
      if (currentState is AddToCartItemAddedSuccessState) {
        emit(AddToCartItemAddedSuccessState(
          cartItems: currentState.cartItems,
          offerState: FirstTransactionState(),
        ));
      }
    });


    double calculateDiscountedAmount(double amount, OfferState? offerState) {
      if (offerState is SBIState) {
        return amount * (1 - offerState.discountPercentage);
      } else if (offerState is AxisState) {
        return amount * (1 - offerState.discountPercentage);
      } else if (offerState is FirstTransactionState) {
        return amount * (1 - offerState.discountPercentage);
      } else {
        return amount; // Default: no discount
      }
    }

    String getOfferDescription(OfferState? offerState) {
      if (offerState is SBIState) {
        return '3% Discount on SBI credit card';
      } else if (offerState is AxisState) {
        return '5% Discount on Axis credit card';
      } else if (offerState is FirstTransactionState) {
        return 'Flat 2% off on first transaction';
      } else {
        return 'No offer applied';
      }
    }


    on<PlaceOrderEvent>((event, emit) async {
      if (state is AddToCartItemAddedSuccessState) {
        try {
          final selectedItems = (state as AddToCartItemAddedSuccessState)
              .cartItems
              .where((item) => item.isSelected)
              .toList();

          final orderId = UniqueKey().toString();
          await _dataBaseHelper.saveOrderHistory(orderId, selectedItems);

          emit(OrderPlacedState(orderId));
        } catch (e) {
          emit(AddToCartErrorState("Failed to place order."));
        }
      }
    });

  }
}
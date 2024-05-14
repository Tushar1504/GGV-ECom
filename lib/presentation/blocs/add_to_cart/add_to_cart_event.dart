part of 'add_to_cart_bloc.dart';

@immutable
sealed class AddToCartEvent {}

class AddToCartInitialEvent extends AddToCartEvent {}

class RemoveProductFromCartEvent extends AddToCartEvent {
  final int id;
  RemoveProductFromCartEvent(this.id);
}

class CheckedItemsInCartEvent extends AddToCartEvent {
  final List<CartItemModel> checkedItems;
  final bool? onCLick;
  final int? index;
  CheckedItemsInCartEvent({required this.checkedItems,this.onCLick,this.index, required bool onClick});
}

class OnAddButtonEvent extends AddToCartEvent {
  final List<CartItemModel> cartList;
  int? quantity;
  final int? index;
  double? totalPrice;
  OnAddButtonEvent({required this.cartList,this.quantity,this.index, this.totalPrice});
}

class OnMinusButtonEvent extends AddToCartEvent {
  final List<CartItemModel> cartList;
  int? quantity;
  final int? index;
  double? totalPrice;
  OnMinusButtonEvent({required this.cartList,this.quantity,this.index, this.totalPrice});
}

class SelectSBIEvent extends AddToCartEvent {
  final int index;
  SelectSBIEvent(this.index);
}

class SelectAxisEvent extends AddToCartEvent {
  final int index;
  SelectAxisEvent(this.index);
}

class SelectFirstTransactionEvent extends AddToCartEvent {
  final int index;
  SelectFirstTransactionEvent(this.index);
}

class PlaceOrderEvent extends AddToCartEvent {
  PlaceOrderEvent();
}
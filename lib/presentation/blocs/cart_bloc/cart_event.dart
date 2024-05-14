part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

class FetchCartItemEvent extends CartEvent{}

class AddCartItemEvent extends CartEvent{
  final CartModel items;

  AddCartItemEvent({required this.items});
}

class CartItemUpdateEvent extends CartEvent{
  final int id;
  final String product;
  final String description;
  final double amount;

  CartItemUpdateEvent({required this.id, required this.product, required this.description, required this.amount});
}

class CartItemDeleteEvent extends CartEvent{
  final int id;
  CartItemDeleteEvent(this.id);
}

class CartItemAddedOnClickedEvent extends CartEvent{
final CartItemModel clickedItem;

  CartItemAddedOnClickedEvent({required this.clickedItem});
}

class CartItemIncreaseQuantityEvent extends CartEvent{
  final int itemId;

  CartItemIncreaseQuantityEvent({required this.itemId});
}

//for search cart items

class CartItemSearchEvent extends CartEvent {
  final String keywords;

  CartItemSearchEvent(this.keywords);
}

class CartItemSearchedEvent extends CartEvent {
  CartItemSearchedEvent({required this.items});
  final List<CartModel> items;
}
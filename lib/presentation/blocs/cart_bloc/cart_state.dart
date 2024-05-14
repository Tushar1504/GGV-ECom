part of 'cart_bloc.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}

final class CartScreenLoadingState extends CartState{}

final class CartScreenLoadedState extends CartState{
  final List<CartModel> cartItems;

  CartScreenLoadedState({required this.cartItems});
}

final class CartItemUpdateState extends CartState{
  final int id;
  CartItemUpdateState(this.id);
}

final class CartItemCreatedState extends CartState{
  final int id;
  CartItemCreatedState(this.id);
}

final class CartItemAddedOnClickedState extends CartState{
  final int id;
  CartItemAddedOnClickedState(this.id);
}

final class CartItemAddedState extends CartState{
  final int id;
  CartItemAddedState(this.id);
}

final class CartErrorState extends CartState{
  final String errorMessage;

  CartErrorState(this.errorMessage);
}

final class CartItemDeleteState extends CartState{
  final int id;
  CartItemDeleteState(this.id);
}

//for search cart items
class CartItemSearchState extends CartState {
  CartItemSearchState({required this.items});
  final List<CartModel> items;
}

final class SearchLoadingState extends CartState {}

final class SearchError extends CartState {
  final String message;

  SearchError(this.message);
}


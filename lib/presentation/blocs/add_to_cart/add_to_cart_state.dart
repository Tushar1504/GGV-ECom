part of 'add_to_cart_bloc.dart';

@immutable
sealed class AddToCartState {}

final class AddToCartInitial extends AddToCartState {}

final class AddToCartLoadingState extends AddToCartState {}

final class AddToCartItemAddedSuccessState extends AddToCartState {
  final List<CartItemModel> cartItems;
  final OfferState? offerState;

  AddToCartItemAddedSuccessState({required this.cartItems, this.offerState});
}

final class ItemRemovedFromCartState extends AddToCartState {
  final int id;
  ItemRemovedFromCartState(this.id);
}

final class CheckedItemsToPaymentScreenState extends AddToCartState {
  final List<CartItemModel> checkedItems;
  final OfferState? offerState;

  CheckedItemsToPaymentScreenState(this.checkedItems, this.offerState);
}

final class AddToCartErrorState extends AddToCartState {
  final String message;

  AddToCartErrorState(this.message);
}

abstract class OfferState {}

class SBIState extends OfferState {
  final double discountPercentage = 0.03;
}

class AxisState extends OfferState {
  final double discountPercentage = 0.05;
}

class FirstTransactionState extends OfferState {
  final double discountPercentage = 0.02;
}

class OrderPlacedState extends AddToCartState {
  final String orderId;
  OrderPlacedState(this.orderId);
}


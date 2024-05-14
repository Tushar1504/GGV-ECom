part of 'order_history_bloc.dart';

@immutable
sealed class OrderHistoryState {}

final class OrderHistoryInitial extends OrderHistoryState {}


final class OrderHistoryLoading extends OrderHistoryState {}

final class FetchOrderHistoryState extends OrderHistoryState {
  final List<Map<String, dynamic>> orderHistoryList;

  FetchOrderHistoryState({required this.orderHistoryList});
}

final class OrderHistoryLoadingError extends OrderHistoryState {
  final String message;

  OrderHistoryLoadingError(this.message);
}

final class OrderDetailsFetchingState extends OrderHistoryState {
  final List<Map<String, dynamic>> orderDetailsList;

  OrderDetailsFetchingState({required this.orderDetailsList});
}
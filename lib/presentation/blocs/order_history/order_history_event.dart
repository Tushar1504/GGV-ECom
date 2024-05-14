part of 'order_history_bloc.dart';

@immutable
sealed class OrderHistoryEvent {}

final class OrderHistoryFetchingEvent extends OrderHistoryEvent {}

final class OrderDetailsFetchingEvent extends OrderHistoryEvent {}

final class FetchOrderDetailsEvent extends OrderHistoryEvent {
  final String orderId;

  FetchOrderDetailsEvent({required this.orderId});
}
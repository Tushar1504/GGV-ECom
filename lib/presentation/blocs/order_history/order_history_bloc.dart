import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/data_sources/remote/sqlite.dart';

part 'order_history_event.dart';
part 'order_history_state.dart';


class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  final DataBaseHelper _dataBaseHelper;
  OrderHistoryBloc({required DataBaseHelper dataBaseHelper})
      : _dataBaseHelper = dataBaseHelper,
        super(OrderHistoryInitial()) {
    on<OrderHistoryFetchingEvent>((event, emit) async {
      emit(OrderHistoryLoading());
      try {
        final orders = await _dataBaseHelper.fetchOrderHistory();
        emit(FetchOrderHistoryState(orderHistoryList: orders));
      } catch (e) {
        emit(OrderHistoryLoadingError("Error fetching order history"));
      }
    });


    on<FetchOrderDetailsEvent>((event, emit) async {
      emit(OrderHistoryLoading());
      try {
        final orders = await _dataBaseHelper.fetchOrderDetails(event.orderId);
        emit(OrderDetailsFetchingState(orderDetailsList: orders));
      } catch (e) {
        emit(OrderHistoryLoadingError("Error fetching order history"));
      }
    });
  }
}
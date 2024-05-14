import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ggv_ecom/data/data_sources/remote/sqlite.dart';
import 'package:ggv_ecom/presentation/blocs/order_history/order_history_bloc.dart';
import 'package:ggv_ecom/presentation/screens/home_page/order_details.dart';

class OrderHistoryScreen extends StatelessWidget {
  OrderHistoryScreen({super.key});

  OrderHistoryBloc orderHistoryBloc = OrderHistoryBloc(dataBaseHelper: DataBaseHelper())..add(OrderHistoryFetchingEvent());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
        bloc: orderHistoryBloc,
        builder: (context, state) {
          if (state is FetchOrderHistoryState) {
            return ListView.builder(
              itemCount: state.orderHistoryList.length,
              itemBuilder: (context1, index) {
                final order = state.orderHistoryList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context1) => OrderDetailScreen(orderId: order["orderId"]),
                      ),
                    ).then((value){
                      orderHistoryBloc.add(OrderHistoryFetchingEvent());
                    });
                  },
                  child: Card(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Order ID: ${order['orderId']}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Total Price: ₹${order['totalAmount'].toStringAsFixed(2)}',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('No orders placed yet.'),
            );
          }
        },
      ),
    );
  }
}
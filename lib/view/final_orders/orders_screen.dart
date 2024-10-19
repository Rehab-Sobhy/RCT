import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/common%20copounents/order_card.dart';
import 'package:rct/view-model/cubits/orders%20list/orders_list_cubit.dart';

class OrderListScreen extends StatelessWidget {
  static String id = "OrderListScreen";

  const OrderListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<OrdersListCubit, OrdersListState>(
        builder: (context, state) {
          if (state is OrdersListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrdersListFailure) {
            return Center(child: Text("'You Don't have orders'"));
          }
          if (state is OrdersListSuccess) {
            return ListView.builder(
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return OrderCard(order: order);
              },
            );
          }
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "You Don't have orders ",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

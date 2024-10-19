import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/view-model/cubits/order%20number/order_number_cubit.dart';

// Import your Cubit class
class OrderNumberScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Numbers"),
      ),
      body: BlocProvider(
        create: (context) => OrderNumberCubit()..fetchOrders(),
        child: BlocBuilder<OrderNumberCubit, OrderNumberState>(
          builder: (context, state) {
            if (state is OrderNumberLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is OrderNumberSuccess) {
              final orderNumbers = state.orderNumber
                  .map((order) => order['number'])
                  .toList(); // Extract only the 'number' field

              return ListView.builder(
                itemCount: orderNumbers.length,
                itemBuilder: (context, index) {
                  final orderNumber = orderNumbers[index];
                  return ListTile(
                    title: Text("Order Number: $orderNumber"),
                  );
                },
              );
            } else if (state is OrderNumberFailure) {
              return Center(
                child: Text(
                  'Failed to load orders: ${state.errMessage}',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }

            return Center(child: Text('No orders to display.'));
          },
        ),
      ),
    );
  }
}

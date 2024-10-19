import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/view-model/functions/compare_date.dart';
import 'package:rct/view/final_orders/final_orders_cubit.dart';
import 'package:rct/view/final_orders/final_orders_states.dart';
import 'package:rct/view/RealEstate/modelget.dart';

class DesignsOrders extends StatefulWidget {
  const DesignsOrders({super.key});

  @override
  State<DesignsOrders> createState() => _DesignsOrdersState();
}

class _DesignsOrdersState extends State<DesignsOrders> {
  @override
  void initState() {
    super.initState();
    // Trigger the loading of data when the widget is first created
    Future.microtask(() {
      FinalOrdersCubit.get(context).DesignsAndScketches();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          BlocConsumer<FinalOrdersCubit, FinalOrdersStates>(
            listener: (context, state) {
              if (state is DesignsFaild) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
                print("Failed to load data: ${state.message}");
              } else if (state is DesignsSuccess) {
                // Data is successfully loaded
                print("Data loaded successfully. Items: ${state.data.length}");
              }
            },
            builder: (context, state) {
              if (state is DesignsLoading) {
                print("Loading data...");
                return const Center(child: CircularProgressIndicator());
              } else if (state is DesignsSuccess) {
                final data = state.data;
                if (data.isNotEmpty) {
                  print("Building list with ${data.length} items...");
                  return Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        print("Displaying item ${index + 1} of ${data.length}");
                        return Card(
                          elevation: 2,
                          color: Colors.white,
                          child: Container(
                            height: 100,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("رقم الطلب",
                                        style: TextStyle(color: Colors.grey)),
                                    SizedBox(height: 8),
                                    Text("${data[index].orderNumber}",
                                        style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("الحالة",
                                        style: TextStyle(color: Colors.grey)),
                                    SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      decoration: BoxDecoration(
                                        color: data[index].status == "pending"
                                            ? Colors.amber
                                            : data[index].status ==
                                                        "accepted" ||
                                                    data[index].status ==
                                                        "approved" ||
                                                    data[index].status ==
                                                        "approve"
                                                ? Colors.green
                                                : Colors.red,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        "${data[index].status}",
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("التاريخ",
                                        style: TextStyle(color: Colors.grey)),
                                    SizedBox(height: 8),
                                    Text(
                                      timeDifferenceFromNow(
                                          "${data[index].created_at}"),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  print("No data available");
                  return const Center(child: Text("No data available"));
                }
              } else {
                print("Unhandled state: ${state.runtimeType}");
                return const Center(child: Text("Something went wrong"));
              }
            },
          ),
        ],
      ),
    );
  }
}

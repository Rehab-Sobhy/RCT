import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rct/view-model/functions/compare_date.dart';
import 'package:rct/view/final_orders/final_orders_cubit.dart';
import 'package:rct/view/final_orders/final_orders_states.dart';
import 'package:rct/view/RealEstate/modelget.dart';

class RowOrdersScreen extends StatefulWidget {
  const RowOrdersScreen({super.key});

  @override
  State<RowOrdersScreen> createState() => _RowOrdersScreenState();
}

class _RowOrdersScreenState extends State<RowOrdersScreen> {
  List<Modelget> data = [];
  bool isloading = true;

  @override
  void initState() {
    super.initState();
    // Trigger the loading of data when the widget is first created
    FinalOrdersCubit.get(context).RawLand();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // const SizedBox(height: 30),
            BlocConsumer<FinalOrdersCubit, FinalOrdersStates>(
              listener: (context, state) {
                if (state is RawLandOrdersFaild) {
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text(state.message)),
                  // );
                  setState(() {
                    isloading = false;
                  });
                  print("Failed to load data: ${state.message}");
                } else if (state is RawLandOrdersSuccess) {
                  setState(() {
                    data = FinalOrdersCubit.get(context).rowlandList;
                    isloading = false;
                  });
                  print("Data loaded successfully. Items: ${data.length}");
                }
              },
              builder: (BuildContext context, Object? state) {
                if (isloading) {
                  // print("Loading data...");
                  return Center(child: Container());
                } else if (data.isNotEmpty) {
                  // print("Building list with ${data.length} items...");
                  return Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        // print("Displaying item ${index + 1} of ${data.length}");
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
                                  children: [
                                    const Text("نوع العقار",
                                        style: TextStyle(color: Colors.grey)),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                        data[index].type == "raw_lands"
                                            ? "${"أرض خام"}"
                                            : data[index].type ==
                                                    "old_buildings"
                                                ? "مباني قديمة"
                                                : "مخططات",
                                        style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      "الحالة",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
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
                                  children: [
                                    const Text("التاريخ",
                                        style: TextStyle(color: Colors.grey)),
                                    SizedBox(
                                      height: 8,
                                    ),
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
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

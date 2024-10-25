import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/view-model/functions/compare_date.dart';
import 'package:rct/view/final_orders/final_orders_cubit.dart';
import 'package:rct/view/final_orders/final_orders_states.dart';
import 'package:rct/view/RealEstate/modelget.dart';

class RealstateOrders extends StatefulWidget {
  const RealstateOrders({super.key});

  @override
  State<RealstateOrders> createState() => _RealstateOrdersState();
}

class _RealstateOrdersState extends State<RealstateOrders> {
  List<Modelget> data = [];
  bool isloading = true;

  @override
  void initState() {
    super.initState();
    // Trigger the loading of data when the widget is first created
    FinalOrdersCubit.get(context).RealOrders();
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
                if (state is RealEstateOrdersFaild) {
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text(state.message)),
                  // );
                  setState(() {
                    isloading = false;
                  });
                } else if (state is RealEstateOrdersSuccess) {
                  setState(() {
                    data = FinalOrdersCubit.get(context).realList;
                    isloading = false;
                  });
                }
              },
              builder: (BuildContext context, Object? state) {
                if (isloading) {
                  return Center(child: Container());
                } else if (data.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
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
                                    Text("${data[index].house_type}",
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

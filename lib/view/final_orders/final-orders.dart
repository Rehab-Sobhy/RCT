import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/view/final_orders/designs_orders.dart';
import 'package:rct/view/final_orders/raw_orders.dart';
import 'package:rct/view/final_orders/realstate_orders.dart';

import 'package:rct/view/final_orders/orders_screen.dart';

class FinalOrdersScreen extends StatefulWidget {
  const FinalOrdersScreen({super.key});

  @override
  State<FinalOrdersScreen> createState() => _FinalOrdersScreenState();
}

class _FinalOrdersScreenState extends State<FinalOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0, scrolledUnderElevation: 0.0,
          centerTitle: true,
          title: Image.asset(
            "assets/images/photo_2024-09-16_00-14-11.jpg",
            fit: BoxFit.contain,
            width: 100,
            height: 100,
          ),
          // backgroundColor: primaryColor,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_sharp,
              color: Colors.black,
            ),
          ),
          bottom: TabBar(
            tabs: [
              Padding(
                padding: const EdgeInsets.only(right: 0.0, left: 0),
                child: Tab(
                  text: "الحاسبة والمشاريع",
                ),
              ),
              Tab(text: 'شراكة وتعاون'),
              Tab(text: "العروض العقارية"),
              Tab(text: 'التصاميم والمخططات')
            ],
            labelStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              fontFamily: 'Font1',
            ),
            isScrollable: true,
            dragStartBehavior: DragStartBehavior.start,
            unselectedLabelColor: Colors.grey,
            labelColor: primaryColor,
            indicatorColor: primaryColor, tabAlignment: TabAlignment.start,
            unselectedLabelStyle: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              fontFamily: 'Font1',
            ),
            // padding: EdgeInsets.all(3),
          ),
        ),
        body: const TabBarView(children: [
          OrderListScreen(),
          RowOrdersScreen(),
          RealstateOrders(),
          DesignsOrders(),
        ]),
      ),
    );
  }
}

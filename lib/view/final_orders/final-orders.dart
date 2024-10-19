import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/view/final_orders/designs_orders.dart';
import 'package:rct/view/final_orders/raw_orders.dart';
import 'package:rct/view/final_orders/realstate_orders.dart';
import 'package:rct/view/home_screen.dart';
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
          elevation: 0,
          centerTitle: true,
          title: Image.asset(
            "assets/images/header.jpg",
            fit: BoxFit.contain,
            height: 50.h,
            width: 170.w,
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_sharp,
              color: Colors.black,
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                text: "الحاسبة والمشاريع",
              ),
              Tab(text: 'شراكة وتعاون'),
              Tab(text: "العروض العقارية"),
              Tab(text: 'التصاميم والمخططات')
            ],
            labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
            isScrollable: true,
            unselectedLabelColor: Colors.grey,
            labelColor: primaryColor,
            indicatorColor: primaryColor,
            unselectedLabelStyle:
                TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            padding: EdgeInsets.all(3),
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

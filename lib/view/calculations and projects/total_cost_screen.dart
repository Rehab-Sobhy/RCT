import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/common%20copounents/custom_checkbox.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/constants/constants.dart';

import 'package:rct/model/order_model.dart';
import 'package:rct/shared_pref.dart';
import 'package:rct/view/calculations%20and%20projects/confirmation_screen.dart';
import 'package:rct/view/terms_conditions_screen.dart';

class TotalCostScreen extends StatefulWidget {
  const TotalCostScreen({super.key});

  @override
  State<TotalCostScreen> createState() => _TotalCostScreenState();
}

class _TotalCostScreenState extends State<TotalCostScreen> {
  bool showButton = false;
  bool showDetails = false; // Add this flag to show/hide details
  TextEditingController controller = TextEditingController();
  bool isChecked = false;

  double? fence;
  dynamic? finalFormsPrice;
  double? floorTotal;
  double? excavationAndBackfill;
  double? bridgesSpace;
  double? all;
  // Loading data from shared preferences
  Future<void> loadDataFromPreferences() async {
    fence = AppPreferences.getData(key: 'fence');
    finalFormsPrice = AppPreferences.getData(key: 'Finalforms');
    floorTotal = AppPreferences.getData(key: 'floorTotal');
    bridgesSpace = AppPreferences.getData(key: 'bridge');
    all = AppPreferences.getData(key: 'all');
    excavationAndBackfill =
        AppPreferences.getData(key: 'excavationandbackfill');

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadDataFromPreferences();
  }

  // Method to toggle details visibility
  void toggleDetailsVisibility() {
    setState(() {
      showDetails = !showDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    OrderModel orderModel = Provider.of<OrderModel>(context, listen: false);
    final formattedCost = NumberFormat('#,###').format(orderModel.cost);
    var local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButtonAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
            ),
            Center(
              child: Text(
                local.totalProjectCost,
                style: TextStyle(
                  fontSize: 12,
                  color: blackColor.withOpacity(0.5),
                ),
              ),
            ),
            SizedBox(height: constVerticalPadding),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: grey,
                borderRadius: BorderRadius.circular(10),
              ),
              width: 400.w,
              height: 50,
              child: Text(
                "$formattedCost ${local.sar}",
                style: TextStyle(
                  fontSize: 15,
                  color: blackColor.withOpacity(0.5),
                ),
              ),
            ),
            SizedBox(height: constVerticalPadding),
            Padding(
              padding: const EdgeInsets.all(3),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.start, // Align Row content to start
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "تفاصيل البناء",
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      showDetails ? Icons.expand_less : Icons.expand_more,
                      color: primaryColor,
                    ),
                    onPressed:
                        toggleDetailsVisibility, // Toggle details visibility
                  ),
                ],
              ),
            ),

// Conditionally display details based on showDetails flag
            if (showDetails) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8.0), // Add padding to all content
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align Row vertically to start
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Align all text to the start
                        children: [
                          Text(
                            '''
خزان المياه: 23 
خزان الصرف: 7 
السور: ${fence?.toStringAsFixed(2) ?? ''}
تشطيب الواجهات: ${finalFormsPrice?.toStringAsFixed(2) ?? ''}
الجسور المقلوبة: ${bridgesSpace?.toStringAsFixed(2) ?? ''}
${orderModel.has_pool == 1 ? "المسبح: ${orderModel.SwimmingPool}" : ""}
${orderModel.islandChecked == 0 ? "فحص التربة: 2000" : ""}
مساحة الادوار : ${floorTotal?.toStringAsFixed(2) ?? ''}''',
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                          SizedBox(height: 5), // Add space between texts
                          Text(
                            "مجموع مسطحات البناء: ${all?.toStringAsFixed(2) ?? ''}",
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "رسوم الحفر والردم: ${excavationAndBackfill?.toStringAsFixed(2) ?? ''}",
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: 10),

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomCheckbox(
                    isChecked: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value!;
                        showButton = value ? true : false;
                      });
                    },
                  ),
                ),
                Text(local.agreeToTermsAndConditions),
              ],
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TermsAndConditionsScreen()));
              },
              child: Text(
                local.termsConditions,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Colors.blue,
                    ),
              ),
            ),
            SizedBox(height: constVerticalPadding),
            SizedBox(height: 10),
            showButton
                ? MainButton(
                    text: local.next,
                    backGroundColor: primaryColor,
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ConfirmationScreen())),
                  )
                : Container(),
            SizedBox(height: constVerticalPadding),
            // Toggle button to show/hide details
          ],
        ),
      ),
    );
  }
}

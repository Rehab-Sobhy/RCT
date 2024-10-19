// import 'dart:math';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:provider/provider.dart';
// import 'package:rct/common%20copounents/app_bar_back_button.dart';
// import 'package:rct/common%20copounents/main_button.dart';
// import 'package:rct/constants/constants.dart';
// import 'package:rct/model/build_types_model.dart';
// import 'package:rct/model/complex_model.dart';
// import 'package:rct/model/order_model.dart';
// import 'package:rct/shared_pref.dart';
// import 'package:rct/view-model/cubits/build_types_and_floors/build_types_and_floors_cubit.dart';
// import 'package:rct/view-model/functions/cost_calc.dart';
// import 'package:rct/view-model/functions/snackbar.dart';
// import 'package:rct/view/calculations%20and%20projects/percentsmodel.dart';
// import 'package:rct/view/calculations%20and%20projects/total_cost_screen.dart';

// class Floor3maaerDetails extends StatefulWidget {
//   const Floor3maaerDetails({super.key});

//   @override
//   State<Floor3maaerDetails> createState() => _Floor3maaerDetailsState();
// }

// class _Floor3maaerDetailsState extends State<Floor3maaerDetails> {
//   List<PercentageData> globalPercentageData = [];
//   double firstPercentage = 0;
//   double secondPercentage = 0;
//   double lastPercentage = 0;

//   Future<void> fetchPercentageData() async {
//     try {
//       Dio dio = Dio();
//       final response =
//           await dio.get('https://rctapp.com/api/residentialbuilding');

//       List<dynamic> data = response.data;
//       globalPercentageData =
//           data.map((json) => PercentageData.fromJson(json)).toList();

//       if (globalPercentageData.isNotEmpty) {
//         setState(() {
//           firstPercentage = globalPercentageData[0].firstPercentage / 100;
//           secondPercentage = globalPercentageData[0].secondPercentage / 100;
//           lastPercentage = globalPercentageData[0].lastPercentage / 100;
//         });
//       }
//     } catch (e) {
//       print("Error fetching data: $e");
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchPercentageData();
//     context.read<BuildTypesAndFloorsCubit>().getBuildTypes(context);
//   }

//   TextEditingController controller = TextEditingController();
//   int? _selectedCardIndex;
//   List<String> buildTypesModel = [];
//   bool isLoading = false;

//   String? selectedName;
//   dynamic selectedPrice;

//   @override
//   Widget build(BuildContext context) {
//     OrderModel orderModel = Provider.of<OrderModel>(context, listen: false);
//     ComplexModel complexModel =
//         Provider.of<ComplexModel>(context, listen: false);

//     var local = AppLocalizations.of(context)!;
//     double floorTotal = 0.0;

//     Map<String, String> complexMap = {
//       "الدور الاول %": "75",
//       " الادوار المتكررة %": "65",
//       "الملحق %": "52.5",
//     };

//     late dynamic fencepercent;
//     late dynamic fonalFormsPrice;

//     double excavationandbackfill = orderModel.areaspace * 1.5 * 57;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: BackButtonAppBar(context),
//       body: ModalProgressHUD(
//         inAsyncCall: isLoading,
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     height: MediaQuery.sizeOf(context).height / 2.5,
//                     child: ListView(
//                       children: [
//                         FloorDetails(
//                           number: orderModel.areaspace * firstPercentage,
//                           text: "الدور الاول ",
//                         ),
//                         FloorDetails(
//                           number: orderModel.areaspace * secondPercentage,
//                           text: "  الادوار المتكررة ",
//                         ),
//                         FloorDetails(
//                           number: orderModel.areaspace * lastPercentage,
//                           text: "الملحق",
//                         ),
//                       ],
//                     ),
//                   ),
//                   Text(
//                     local.typeOfBuilding,
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: blackColor.withOpacity(0.5),
//                     ).copyWith(
//                       fontWeight: mainFontWeight,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 80.h,
//                     width: double.infinity,
//                     child: ListView(
//                       scrollDirection: Axis.horizontal,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               selectedName = "عادي";
//                               _selectedCardIndex = 0;
//                               selectedPrice = 1650;
//                             });
//                             AppPreferences.saveData(key: "type", value: 1);
//                           },
//                           child: SizedBox(
//                             height: 80,
//                             width: 120,
//                             child: Card(
//                               color: _selectedCardIndex == 0
//                                   ? Colors.grey
//                                   : Colors.white,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Center(child: Text("عادي 1650 ريال")),
//                               ),
//                             ),
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               selectedName = "ديلوكس";
//                               _selectedCardIndex = 1;
//                               selectedPrice = 1950;
//                             });
//                             AppPreferences.saveData(key: "type", value: 2);
//                           },
//                           child: SizedBox(
//                             height: 80,
//                             width: 120,
//                             child: Card(
//                               color: _selectedCardIndex == 1
//                                   ? Colors.grey
//                                   : Colors.white,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Center(child: Text("ديلوكس 1950 ريال")),
//                               ),
//                             ),
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               selectedName = "سوبر ديلوكس";
//                               _selectedCardIndex = 2;
//                               selectedPrice = 2250;
//                             });
//                             AppPreferences.saveData(key: "type", value: 3);
//                           },
//                           child: SizedBox(
//                             height: 80,
//                             width: 120,
//                             child: Card(
//                               color: _selectedCardIndex == 2
//                                   ? Colors.grey
//                                   : Colors.white,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Center(
//                                     child: Text("سوبر ديلوكس 2250 ريال")),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: constVerticalPadding),
//                   Center(
//                     child: MainButton(
//                       text: local.next,
//                       backGroundColor: primaryColor,
//                       onTap: () async {
//                         fencepercent = orderModel.streetDetails == "شارع واحد"
//                             ? 1.97
//                             : orderModel.streetDetails == "شارعين"
//                                 ? 1.8
//                                 : orderModel.streetDetails == " ثلاث شوارع"
//                                     ? 1.65
//                                     : 1.5;

//                         double Fence = ((orderModel.areaspace / 20) * 2 + 40) /
//                             fencepercent;

//                         double WaterTank = 23;
//                         double SewageTank = 7;
//                         double bridgesSpace =
//                             ((floorTotal / 10) * 650) / selectedPrice;

//                         fonalFormsPrice = orderModel.finalForm ==
//                                 'واجهة ديكورية'
//                             ? sqrt(orderModel.areaspace * 12 / 150) /
//                                 selectedPrice
//                             : orderModel.finalForm == 'واجهة حجر'
//                                 ? (sqrt(orderModel.areaspace) * 12 * 1 * 180) /
//                                     selectedPrice
//                                 : orderModel.finalForm == "واجهتين حجر"
//                                     ? (sqrt(orderModel.areaspace) *
//                                             12 *
//                                             2 *
//                                             180) /
//                                         selectedPrice
//                                     : orderModel.finalForm == "ثلاث واجهات حجر"
//                                         ? (sqrt(orderModel.areaspace) *
//                                                 12 *
//                                                 3 *
//                                                 180) /
//                                             selectedPrice
//                                         : orderModel.finalForm ==
//                                                 "اربع واجهات حجر"
//                                             ? (sqrt(orderModel.areaspace) *
//                                                     12 *
//                                                     4 *
//                                                     180) /
//                                                 selectedPrice
//                                             : 0;

//                         if (selectedName != null && selectedPrice != null) {
//                           if (kDebugMode) {
//                             print('Selected Name: $selectedName');
//                             print('Selected Price: $selectedPrice');
//                           }

//                           orderModel.cost = selectedPrice! *
//                                   (floorTotal +
//                                       Fence +
//                                       WaterTank +
//                                       SewageTank +
//                                       orderModel.SwimmingPool +
//                                       fonalFormsPrice +
//                                       bridgesSpace) +
//                               excavationandbackfill;
//                           await CostCalc().calc(context);

//                           print(
//                               "Total Cost: ${(floorTotal + Fence + WaterTank + SewageTank + orderModel.SwimmingPool + fonalFormsPrice + bridgesSpace)} + cost: ${orderModel.cost}");

//                           Navigator.of(context).push(MaterialPageRoute(
//                               builder: (context) => TotalCostScreen()));
//                         } else {
//                           showSnackBar(context, "اختر نوع البناء", redColor);
//                         }
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildCard(int index, String text) {
//     return GestureDetector(
//       onTap: () {},
//       child: SizedBox(
//         height: 80.h,
//         width: 120.w,
//         child: Card(
//           color: _selectedCardIndex == index ? darkGrey : whiteBackGround,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Center(child: Text(text)),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class FloorDetails extends StatelessWidget {
//   final String text;
//   final double? number;

//   const FloorDetails({
//     super.key,
//     required this.text,
//     required this.number,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(
//           text,
//           style: TextStyle(
//             fontSize: 12,
//             color: blackColor.withOpacity(0.5),
//           ).copyWith(
//             fontWeight: mainFontWeight,
//           ),
//         ),
//         SizedBox(height: constVerticalPadding),
//         Padding(
//           padding: const EdgeInsets.all(15),
//           child: Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: grey,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Text(
//               "${number!.toStringAsFixed(2)}",
//               style: TextStyle(
//                 fontSize: 10,
//                 color: blackColor,
//               ).copyWith(
//                 fontWeight: mainFontWeight,
//               ),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/model/build_types_model.dart';
import 'package:rct/model/complex_model.dart';
import 'package:rct/model/order_model.dart';
import 'package:rct/shared_pref.dart';
import 'package:rct/view-model/cubits/build_types_and_floors/build_types_and_floors_cubit.dart';
import 'package:rct/view-model/functions/cost_calc.dart';
import 'package:rct/view-model/functions/snackbar.dart';
import 'package:rct/view/calculations%20and%20projects/total_cost_screen.dart';

class Floor3maaerDetails extends StatefulWidget {
  const Floor3maaerDetails({super.key});

  @override
  State<Floor3maaerDetails> createState() => _Floor3maaerDetailsState();
}

class _Floor3maaerDetailsState extends State<Floor3maaerDetails> {
  TextEditingController controller = TextEditingController();
  int? _selectedCardIndex;
  List<BuildTypesModel> buildTypesModel = [];
  bool isLoading = false;

  String? selectedName;
  dynamic selectedPrice;

  @override
  void initState() {
    super.initState();
    context.read<BuildTypesAndFloorsCubit>().getBuildTypes(context);
  }

  @override
  Widget build(BuildContext context) {
    OrderModel orderModel = Provider.of<OrderModel>(context, listen: false);
    ComplexModel complexModel =
        Provider.of<ComplexModel>(context, listen: false);

    // selectedPrice! = AppPreferences.getData(key: "price");

    var local = AppLocalizations.of(context)!;
    double floorTotal = 0.0;
    Map<String, String> complexMap = {
      "الدور الاول %": "75",
      " الادوار المتكررة %": "65",
      "الملحق %": "52.5",
    };
    late dynamic fencepercent;
    double test;
    late dynamic fonalFormsPrice;

    double excavationandbackfill = orderModel.areaspace * 1.5 * 57;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButtonAppBar(context),
      body: BlocBuilder<BuildTypesAndFloorsCubit, BuildTypesAndFloorsState>(
        builder: (context, state) {
          if (state is BuildTypesAndFloorsLoading) {
            isLoading = true;
          } else if (state is BuildTypesAndFloorsFailure) {
            isLoading = false;
            return Center(
              child: Text(state.errMessage),
            );
          } else if (state is BuildTypesAndFloorsSuccess) {
            isLoading = false;
            buildTypesModel = state.buildTypes;
            double? floorCount = double.tryParse(complexModel.floorCount);
            if (floorCount != null) {
              double first = orderModel.areaspace *
                  (floorCount - (floorCount - 1)) *
                  (0.75);
              double mid = orderModel.areaspace * (floorCount - 2) * (0.75);
              double last = orderModel.areaspace *
                  (floorCount - (floorCount - 1)) *
                  (0.525);
              floorTotal = first + mid + last;
              test = first + mid + last;
              if (kDebugMode) {
                print(orderModel.floorDetails);
                print(floorCount);
                print(first);
                print(mid);
                print(last);
                print(floorTotal);
              }
            }
          }
          return ModalProgressHUD(
            inAsyncCall: isLoading,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(
                      //   height: MediaQuery.sizeOf(context).height / 2.5,
                      //   child: orderModel.floorDetails.isEmpty
                      //       ? ListView.builder(
                      //           itemCount: 3,
                      //           itemBuilder: (context, index) {
                      //             String key = complexMap.keys.elementAt(index);
                      //             String value = complexMap[key]!;
                      //             return FloorDetails(
                      //                 text: key,
                      //                 number: double.tryParse(value));
                      //           },
                      //         )
                      //       : ListView.builder(
                      //           itemCount: orderModel.floorDetails.length,
                      //           itemBuilder: (context, index) {
                      //             double? size = double.tryParse(
                      //                 orderModel.floorDetails[index]["size"]);
                      //             double number =
                      //                 (size! / 100) * orderModel.areaspace;
                      //             floorTotal += number;
                      //             return FloorDetails(
                      //               text: orderModel.floorDetails[index]["name"]
                      //                   .toString(),
                      //               number: number,
                      //             );
                      //           },
                      //         ),
                      // ),

                      SizedBox(
                        height: MediaQuery.sizeOf(context).height / 2.5,
                        child: ListView(
                          children: [
                            FloorDetails(
                              number: orderModel.areaspace * 75,
                              text: "الدور الاول ",
                            ),
                            FloorDetails(
                              number: orderModel.areaspace * 75,
                              text: "  الادوار المتكررة ",
                            ),
                            FloorDetails(
                              number: orderModel.areaspace * 52.5,
                              text: "الملحق",
                            ),
                          ],
                        ),
                      ),
                      Text(
                        local.typeOfBuilding,
                        style: TextStyle(
                          fontSize: 12,
                          color: blackColor.withOpacity(0.5),
                        ).copyWith(
                          fontWeight: mainFontWeight,
                        ),
                      ),
                      SizedBox(
                        height: 80.h,
                        width: double.infinity,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: buildTypesModel.length,
                            itemBuilder: (context, index) {
                              return buildCard(index,
                                  "${buildTypesModel[index].name!} ${buildTypesModel[index].price!} ريال");
                            }),
                      ),
                      SizedBox(height: constVerticalPadding),
                      Center(
                        child: MainButton(
                          text: local.next,
                          backGroundColor: primaryColor,
                          onTap: () async {
                            fencepercent = orderModel.streetDetails ==
                                    "شارع واحد"
                                ? 1.97
                                : orderModel.streetDetails == "شارعين"
                                    ? 1.8
                                    : orderModel.streetDetails == " ثلاث شوارع"
                                        ? 1.65
                                        : 1.5;
                            double Fence =
                                ((orderModel.areaspace / 20) * 2 + 40) /
                                    fencepercent;
                            double WaterTank = 23;
                            double SewageTank = 7;
                            double bridgesSpace =
                                ((floorTotal / 10) * 650) / selectedPrice;

                            fonalFormsPrice = orderModel.finalForm ==
                                    'واجهة ديكورية'
                                ? sqrt(orderModel.areaspace * 12 / 150) /
                                    selectedPrice
                                : orderModel.finalForm == 'واجهة حجر'
                                    ? (sqrt(orderModel.areaspace) *
                                            12 *
                                            1 *
                                            180) /
                                        selectedPrice
                                    : orderModel.finalForm == "واجهتين حجر"
                                        ? (sqrt(orderModel.areaspace) *
                                                12 *
                                                2 *
                                                180) /
                                            selectedPrice
                                        : orderModel.finalForm ==
                                                "ثلاث واجهات حجر"
                                            ? (sqrt(orderModel.areaspace) *
                                                    12 *
                                                    3 *
                                                    180) /
                                                selectedPrice
                                            : orderModel.finalForm ==
                                                    "اربع واجهات حجر"
                                                ? (sqrt(orderModel.areaspace) *
                                                        12 *
                                                        4 *
                                                        180) /
                                                    selectedPrice
                                                : 0;

                            if (selectedName != null && selectedPrice != null) {
                              // Use selectedName and selectedPrice here
                              if (kDebugMode) {
                                print('Selected Name: $selectedName');
                                print('Selected Price: $selectedPrice');
                              }
                              // double? cost = double.tryParse(orderModel.cost as String);

                              orderModel.cost = selectedPrice! *
                                      (floorTotal +
                                          Fence +
                                          WaterTank +
                                          SewageTank +
                                          orderModel.SwimmingPool +
                                          fonalFormsPrice +
                                          bridgesSpace) +
                                  excavationandbackfill;
                              await CostCalc().calc(context);

                              print(
                                  "  $floorTotal + $Fence+ $fonalFormsPrice + $bridgesSpace+ $WaterTank+ $SewageTank+  total ${(floorTotal + Fence + WaterTank + SewageTank + orderModel.SwimmingPool + fonalFormsPrice + bridgesSpace)} + cost ${orderModel.cost} ");
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => TotalCostScreen()));
                            } else {
                              showSnackBar(
                                  context, "اختر نوع البناء", redColor);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildCard(int index, String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCardIndex = index;
          selectedName = buildTypesModel[index].name;
          selectedPrice = double.tryParse(buildTypesModel[index].price!);
          AppPreferences.saveData(
              key: "type", value: buildTypesModel[index].id);
        });
      },
      child: SizedBox(
        height: 80.h,
        width: 120.w,
        child: Card(
          color: _selectedCardIndex == index ? darkGrey : whiteBackGround,
          surfaceTintColor: whiteBackGround,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text(text)),
          ),
        ),
      ),
    );
  }
}

class FloorDetails extends StatelessWidget {
  final String text;
  final double? number;
  const FloorDetails({
    super.key,
    required this.text,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: blackColor.withOpacity(0.5),
          ).copyWith(
            fontWeight: mainFontWeight,
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
          height: 50.h,
          child: Text(
            number.toString(),
          ),
        ),
        SizedBox(
          height: constVerticalPadding,
        ),
      ],
    );
  }
}

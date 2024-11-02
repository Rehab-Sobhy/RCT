import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/model/build_types_model.dart';
import 'package:rct/model/complex_model.dart';
import 'package:rct/model/order_model.dart';
import 'package:rct/shared_pref.dart';
import 'package:rct/view-model/cubits/build_types_and_floors/build_types_and_floors_cubit.dart';
import 'package:rct/view-model/functions/snackbar.dart';
import 'package:rct/view/calculations%20and%20projects/percentsmodel.dart';
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
  dynamic selectedPrice = 1;

  @override
  void initState() {
    super.initState();
    fetchPercentageData();
    context.read<BuildTypesAndFloorsCubit>().getBuildTypes(context);
  }

  List<PercentageData> globalPercentageData = [];
  double firstPercentage = 0.0;
  double secondPercentage = 0.0;
  double lastPercentage = 0.0;
  Future<void> fetchPercentageData() async {
    try {
      Dio dio = Dio();
      final response =
          await dio.get('https://rctapp.com/api/residentialbuilding');

      List<dynamic> data = response.data;
      globalPercentageData =
          data.map((json) => PercentageData.fromJson(json)).toList();
      if (globalPercentageData.isNotEmpty) {
        print(
            "First Percentage (raw): ${globalPercentageData[0].firstPercentage}");
        print(
            "Second Percentage (raw): ${globalPercentageData[0].secondPercentage}");
        print(
            "Last Percentage (raw): ${globalPercentageData[0].lastPercentage}");

        setState(() {
          firstPercentage = globalPercentageData[0].firstPercentage / 100;
          secondPercentage = globalPercentageData[0].secondPercentage / 100;
          lastPercentage = globalPercentageData[0].lastPercentage / 100;
        });

        print("First Percentage: $firstPercentage");
        print("Second Percentage: $secondPercentage");
        print("Last Percentage: $lastPercentage");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    OrderModel orderModel = Provider.of<OrderModel>(context, listen: false);
    ComplexModel complexModel =
        Provider.of<ComplexModel>(context, listen: false);

    // selectedPrice! = AppPreferences.getData(key: "price");

    var local = AppLocalizations.of(context)!;
    double floorTotal = 0.0;
    dynamic num;
    late dynamic fencepercent;
    double test;
    late dynamic fonalFormsPrice;

    double excavationandbackfill = orderModel.areaspace * 1.5 * 57;
    num = double.tryParse(complexModel.floorCount) ?? -2;
    // num = num - 2;
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
                  firstPercentage;
              double mid =
                  orderModel.areaspace * (floorCount - 2.0) * secondPercentage;
              double last = orderModel.areaspace *
                  (floorCount - (floorCount - 1)) *
                  lastPercentage;
              floorTotal = first + mid + last;
              test = first + mid + last;
              if (kDebugMode) {}
            }
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height / 2.5,
                      child: ListView(
                        children: [
                          FloorDetails(
                            number: orderModel.areaspace * firstPercentage,
                            text: "مساحة الدور الأول ",
                          ),
                          FloorDetails(
                            number: orderModel.areaspace *
                                secondPercentage *
                                (num - 2),
                            text: "مساحة الأدوار المتكررة ",
                          ),
                          FloorDetails(
                            number: orderModel.areaspace * lastPercentage,
                            text: "مساحة الملحق",
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
                      height: constVerticalPadding,
                    ),
                    SizedBox(
                      height: 80,
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                10.0), // Adjust the value for equal spacing
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: buildTypesModel.length,
                          itemBuilder: (context, index) {
                            return buildCard(
                              index,
                              ''' ${buildTypesModel[index].name!}''',
                              '''${buildTypesModel[index].price!}''',
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: constVerticalPadding),
                    Center(
                      child: MainButton(
                        text: local.next,
                        backGroundColor: primaryColor,
                        onTap: () async {
                          fencepercent = orderModel.streetDetails == "شارع واحد"
                              ? 1.97
                              : orderModel.streetDetails == "شارعين"
                                  ? 1.8
                                  : orderModel.streetDetails == " ثلاث شوارع"
                                      ? 1.65
                                      : 1.5;
                          double Fence =
                              (((orderModel.areaspace / 20) * 2 + 40) /
                                      fencepercent) /
                                  2;
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
                            AppPreferences.saveData(key: 'fence', value: Fence);
                            AppPreferences.saveData(
                                key: 'Finalforms', value: fonalFormsPrice);

                            double all = (floorTotal +
                                Fence +
                                WaterTank +
                                SewageTank +
                                orderModel.SwimmingPool +
                                fonalFormsPrice +
                                bridgesSpace);
                            AppPreferences.saveData(key: 'all', value: all);
                            AppPreferences.saveData(
                                key: 'floorTotal', value: floorTotal);
                            //excavationandbackfill
                            dynamic islandChecked =
                                orderModel.islandChecked == 1 ? 0 : 2000;
                            AppPreferences.saveData(
                                key: 'excavationandbackfill',
                                value: excavationandbackfill);

                            AppPreferences.saveData(
                                key: 'bridge', value: bridgesSpace);
                            print("**");

                            print(all * selectedPrice);
                            print(all * selectedPrice + excavationandbackfill);
                            double cost =
                                all * selectedPrice + excavationandbackfill;
                            print("**");
                            orderModel.cost = selectedPrice! * all +
                                excavationandbackfill +
                                islandChecked;

                            // await CostCalc().calc(context);

                            print(
                                "  $floorTotal + $Fence+ $fonalFormsPrice + $bridgesSpace+ $WaterTank+ $SewageTank+  total ${(floorTotal + Fence + WaterTank + SewageTank + orderModel.SwimmingPool + fonalFormsPrice + bridgesSpace)} + cost ${orderModel.cost} ");
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => TotalCostScreen()));
                          } else {
                            showSnackBar(context, "اختر نوع البناء", redColor);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildCard(int index, String text, String price) {
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
      child: IntrinsicHeight(
        child: Container(
          width: 120.w,
          child: Card(
            color: _selectedCardIndex == index ? darkGrey : whiteBackGround,
            surfaceTintColor: whiteBackGround,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Column(
                children: [
                  Text(text),
                  Text(price),
                ],
              )),
            ),
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
          height: 50,
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

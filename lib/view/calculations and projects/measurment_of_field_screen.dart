import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/common%20copounents/custom_dropdownlist.dart';
import 'package:rct/common%20copounents/custom_textFormField.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/constants/constants.dart';

import 'package:rct/model/complex_model.dart';
import 'package:rct/model/order_model.dart';

import 'package:rct/view-model/cubits/complex/complex_cubit.dart';
import 'package:rct/view-model/functions/snackbar.dart';
import 'package:rct/view-model/services/create_areaspace.dart';
import 'package:rct/view/calculations%20and%20projects/floor_detailsFor3Amaaer.dart';

class MeasurmentOfFieldScreen extends StatefulWidget {
  static String id = "MeasurmentOfFieldScreen";

  const MeasurmentOfFieldScreen({super.key});

  @override
  State<MeasurmentOfFieldScreen> createState() =>
      _MeasurmentOfFieldScreenState();
}

class _MeasurmentOfFieldScreenState extends State<MeasurmentOfFieldScreen> {
  String? selectedName;
  double? selectedPrice;

  List<String> finishitem = [
    'بدون حجر',
    'واجهة حجر',
    'واجهتين حجر',
    'ثلاث واجهات حجر',
    'اربع واجهات حجر',
    'واجهة ديكورية',
  ];

  List<String> landItem = [
    'شارع واحد',
    'شارعين',
    'ثلاثة شوارع',
    'أربع شوارع',
  ];
  String? _selectedType;
  String? _selectedType2;
  int? selectedId;
  bool islandChecked = false;
  bool showButton = false;
  TextEditingController apartmentController = TextEditingController();
  TextEditingController floorsController = TextEditingController();
  TextEditingController controller = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  // bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    ComplexModel complexModel =
        Provider.of<ComplexModel>(context, listen: false);
    OrderModel orderModel = Provider.of<OrderModel>(context, listen: false);
    var local = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButtonAppBar(context),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    local.totalLandArea,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ).copyWith(
                      fontWeight: mainFontWeight,
                    ),
                  ),
                  SizedBox(height: constVerticalPadding + 10),
                  TextFormFieldCustom(
                    context: context,
                    labelText: local.pleaseEnterTotalArea,
                    onChanged: (value) {},
                    controller: controller,
                    border: true,
                    number: true,
                  ),
                  SizedBox(height: constVerticalPadding),

                  CustomDropDownList(
                    list: finishitem,
                    selectedValue: _selectedType,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedType = newValue!;
                        orderModel.finalForm = newValue;
                      });
                    },
                    hint: "تشطيب الواجهات",
                  ),
                  SizedBox(height: constVerticalPadding),
                  CustomDropDownList(
                    list: landItem,
                    selectedValue: _selectedType2,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedType2 = newValue!;
                        orderModel.streetDetails = newValue;
                      });
                    },
                    hint: "تفاصيل الأرض",
                  ),

                  SizedBox(height: constVerticalPadding),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   local.numberOfFloors,
                      //   style: Theme.of(context)
                      //       .textTheme
                      //       .bodySmall!
                      //       .copyWith(fontSize: 12),
                      // ),

                      TextFormFieldCustom(
                        context: context,
                        labelText: local.enterNumberOfFloors,
                        controller: floorsController,
                        onChanged: (value) {},
                      ),
                      SizedBox(height: constVerticalPadding),
                      // Checkbox and Text

                      Row(
                        children: [
                          Checkbox(
                            activeColor: primaryColor,
                            value: islandChecked,
                            onChanged: (value) {
                              setState(() {
                                islandChecked = value!;
                              });
                            },
                          ),
                          Text(
                            local.landcheck,
                            style: TextStyle(fontSize: 12),
                          ), // Update this with appropriate localization key
                        ],
                      ),

                      SizedBox(height: constVerticalPadding),
                      SizedBox(height: constVerticalPadding),
                      Center(
                        child: MainButton(
                          text: local.next,
                          backGroundColor: primaryColor,
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                orderModel.SwimmingPool = 0;
                                orderModel.has_pool = 0;

                                isLoading = true;
                                orderModel.areaspace =
                                    double.parse(controller.text);

                                if (islandChecked == false) {
                                  orderModel.islandChecked = 0;
                                } else {
                                  orderModel.islandChecked = 1;
                                }
                              });

                              await CreateAreaSpace()
                                  .create(controller.text, context)
                                  .then((value) => {
                                        value
                                            ? {
                                                setState(() {
                                                  isLoading = false;
                                                }),
                                              }
                                            : {
                                                setState(() {
                                                  isLoading = false;
                                                }),
                                                showSnackBar(
                                                    context,
                                                    local.errorPleaseTryAgain,
                                                    redColor)
                                              }
                                      });
                            }

                            /******************************* */
                            await context
                                .read<ComplexCubit>()
                                .createComplex(complexModel);
                            complexModel.floorCount = floorsController.text;
                            orderModel.floorcount = floorsController.text;
                            complexModel.departmentCount =
                                apartmentController.text;
                            complexModel.buildId = "";
                            orderModel.type_id = "";

                            // Input validation and navigation logic
                            if (complexModel.floorCount != 0 &&
                                orderModel.areaspace != null &&
                                orderModel.finalForm != null &&
                                orderModel.streetDetails != null) {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Floor3maaerDetails(),
                              ));
                            } else {
                              showSnackBar(
                                  context, "من فضلك اكمل المطلوب", redColor);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  // Checkbox and Text

                  SizedBox(height: constVerticalPadding),

                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

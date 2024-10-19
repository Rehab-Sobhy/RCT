import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/common%20copounents/custom_dropdownlist.dart';
import 'package:rct/common%20copounents/custom_textFormField.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/model/build_types_model.dart';
import 'package:rct/model/order_model.dart';
import 'package:rct/shared_pref.dart';
import 'package:rct/view-model/functions/snackbar.dart';
import 'package:rct/view-model/services/create_areaspace.dart';
import 'package:rct/view/calculations%20and%20projects/building_struct_screen.dart';

class MeasurmentOfVilla extends StatefulWidget {
  static String id = "MeasurmentOfFieldScreen";

  const MeasurmentOfVilla({super.key});

  @override
  State<MeasurmentOfVilla> createState() => _MeasurmentOfVillaState();
}

class _MeasurmentOfVillaState extends State<MeasurmentOfVilla> {
  String? selectedName;
  double? selectedPrice;

  int? _selectedCardIndex;
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
  TextEditingController controller = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    OrderModel orderModel = Provider.of<OrderModel>(context, listen: false);
    var local = AppLocalizations.of(context)!;
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
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
                      )!
                          .copyWith(
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
                    // Checkbox and Text

                    Row(
                      children: [
                        Checkbox(
                          activeColor: primaryColor,
                          value: isChecked,
                          onChanged: (value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                        Text(
                          local.addpool,
                          style: TextStyle(fontSize: 12),
                        ), // Update this with appropriate localization key
                      ],
                    ),

                    SizedBox(height: constVerticalPadding),
                    Center(
                      child: MainButton(
                        text: local.next,
                        backGroundColor: primaryColor,
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              if (isChecked == false) {
                                orderModel.SwimmingPool = 0;
                                orderModel.has_pool = 0;
                              } else {
                                orderModel.has_pool = 1;
                                orderModel.SwimmingPool = 48;
                              }
                              isLoading = true;
                              orderModel.areaspace =
                                  double.parse(controller.text);
                            });
                            await CreateAreaSpace()
                                .create(controller.text, context)
                                .then((value) => {
                                      value
                                          ? {
                                              setState(() {
                                                isLoading = false;
                                              }),
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          BuildingStructScreen())),
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
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

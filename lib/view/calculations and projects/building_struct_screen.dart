import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/common%20copounents/custom_dropdownlist.dart';
import 'package:rct/common%20copounents/custom_text.dart';
import 'package:rct/common%20copounents/custom_textformfield.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/model/complex_model.dart';
import 'package:rct/model/order_model.dart';
import 'package:rct/view-model/cubits/complex/complex_cubit.dart';
import 'package:rct/view-model/cubits/types/types_cubit.dart';
import 'package:rct/view-model/functions/snackbar.dart';
import 'package:rct/view/calculations%20and%20projects/floor_details_screen.dart';

class BuildingStructScreen extends StatefulWidget {
  const BuildingStructScreen({Key? key}) : super(key: key);

  @override
  State<BuildingStructScreen> createState() => _BuildingStructScreenState();
}

class _BuildingStructScreenState extends State<BuildingStructScreen> {
  String? _selectedType;
  int? selectedId;
  String? selectedPrice;
  bool showButton = false;
  TextEditingController apartmentController = TextEditingController();
  TextEditingController floorsController = TextEditingController();
  List<dynamic>? data;
  bool isLoading = false;
  List<String> itemNames = [];
  Map<String, Map<String, dynamic>> nameToDetails = {};

  @override
  void initState() {
    super.initState();
    context.read<TypesCubit>().get();
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context)!;
    ComplexModel complexModel =
        Provider.of<ComplexModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButtonAppBar(context),
      body: BlocBuilder<TypesCubit, TypesState>(
        builder: (context, state) {
          OrderModel orderModel =
              Provider.of<OrderModel>(context, listen: false);

          if (state is TypesLoading) {
            isLoading = true;
          } else if (state is TypesFailure) {
            isLoading = false;
            SchedulerBinding.instance.addPostFrameCallback((_) {
              showSnackBar(context, state.errMessage, Colors.red);
            });
          } else if (state is TypesSuccess) {
            isLoading = false;
            data = state.types;
            itemNames = data!.map((item) => item['name'] as String).toList();
            for (var item in data!) {
              nameToDetails[item['name']] = {
                'id': item['id'],
                'price': item['price']
              };
            }
          }

          return BlocListener<ComplexCubit, ComplexState>(
            listener: (context, state) {
              if (state is ComplexLoading) {
                setState(() {
                  isLoading = true;
                });
              } else if (state is ComplexFailure) {
                setState(() {
                  isLoading = false;
                });
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  showSnackBar(context, state.errMessage, Colors.red);
                });
              } else if (state is ComplexSuccess) {
                setState(() {
                  isLoading = false;
                });
                // Navigation logic should be handled in the button handler
              }
            },
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      local.buildingMechanism,
                      style: TextStyle(
                        fontSize: 12,
                        color: blackColor.withOpacity(0.5),
                      ),
                    ),
                    SizedBox(height: constVerticalPadding + 20),
                    CustomDropDownList(
                      list: itemNames,
                      selectedValue: _selectedType,
                      onChanged: (String? newValue) {
                        setState(() {
                          showButton = true;
                          _selectedType = newValue!;
                          selectedId = nameToDetails[newValue]!['id'];
                          selectedPrice = nameToDetails[newValue]!['price'];
                        });
                      },
                      hint: "اختر آلية البناء",
                    ),
                    SizedBox(height: constVerticalPadding),
                    Center(
                      child: showButton
                          ?
                          // . _selectedType == "عمائر" ||
                          //         _selectedType == "عمارات"
                          // ||
                          // _selectedType == "test1"
                          // ? Column(
                          //     crossAxisAlignment:
                          //         CrossAxisAlignment.start,
                          //     children: [
                          //       Text(
                          //         local.numberOfFloors,
                          //         style: Theme.of(context)
                          //             .textTheme
                          //             .bodyLarge,
                          //       ),
                          //       SizedBox(height: constVerticalPadding),
                          //       Center(
                          //         child: MainButton(
                          //           text: local.next,
                          //           backGroundColor: primaryColor,
                          //           onTap: () async {
                          //             await context
                          //                 .read<ComplexCubit>()
                          //                 .createComplex(complexModel);
                          //             complexModel.floorCount =
                          //                 floorsController.text;
                          //             complexModel.departmentCount =
                          //                 apartmentController.text;
                          //             complexModel.buildId =
                          //                 selectedId.toString();
                          //             orderModel.type_id = selectedId!;

                          //             // Input validation and navigation logic

                          //             Navigator.of(context)
                          //                 .push(MaterialPageRoute(
                          //               builder: (context) =>
                          //                   FloorDetailsScreen(),
                          //             ));
                          //           },
                          //         ),
                          //       ),
                          //     ],
                          //   )
                          // :

                          GestureDetector(
                              onDoubleTap: () {
                                orderModel.type_id = selectedId!;

                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => FloorDetailsScreen(),
                                ));
                              },
                              child: Container(
                                  height: 40.h,
                                  width: 335.w,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: CustomText(
                                      text: local.next,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )),
                            )
                          : Container(),
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
}

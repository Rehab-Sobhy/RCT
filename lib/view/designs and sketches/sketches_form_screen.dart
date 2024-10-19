import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/common%20copounents/custom_dropdownlist.dart';
import 'package:rct/common%20copounents/custom_textformfield.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/common%20copounents/pop_up.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/model/order_model.dart';
import 'package:rct/view-model/functions/snackbar.dart';
import 'package:rct/view/RealEstate/model.dart';
import 'package:rct/view/RealEstate/modelget.dart';
import 'package:rct/view/final_orders/final_orders_cubit.dart';
import 'package:rct/view/final_orders/final_orders_states.dart';
import 'package:rct/view/home_screen.dart';

class SketchForm extends StatefulWidget {
  dynamic id;
  SketchForm({super.key, required this.id});

  @override
  State<SketchForm> createState() => _SketchFormState();
}

class _SketchFormState extends State<SketchForm> {
  final TextEditingController controller = TextEditingController();
  String? _selectedType;
  List<String> items = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize items once in initState
    OrderModel orderModel = Provider.of<OrderModel>(context, listen: false);

    items = orderModel.orderNumbers;
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context)!;
    Modelget modelget = Provider.of<Modelget>(context, listen: false);
    HouseModel housemodel = Provider.of<HouseModel>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButtonAppBar(context),
      body: BlocConsumer<FinalOrdersCubit, FinalOrdersStates>(
        listener: (BuildContext context, state) {
          if (state is SketchLoading22) {
            setState(() {
              isLoading = true;
            });
          } else if (state is SketchFaild22) {
            setState(() {
              isLoading = false;
            });
            showSnackBar(context, state.message, redColor);
          } else if (state is SketchSuccess22) {
            setState(() {
              isLoading = false;
            });
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ShowPopUp(
                  title: Center(
                    child: Image.asset(
                      "assets/icons/popUp-icon.png",
                      height: 50.h,
                      width: 50.w,
                    ),
                  ),
                  content: ListTile(
                    titleAlignment: ListTileTitleAlignment.center,
                    title: Text(local.requestSentSuccessfully),
                    subtitle: Text(local.requestWillBeReviewed),
                  ),
                  ontap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (route) => false, // Remove all previous routes
                  ),
                );
              },
            );
          }
        },
        builder: (BuildContext context, Object? state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    local.otherDetailsOrInformation,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: constVerticalPadding),
                  TextFormFieldCustom(
                    context: context,
                    border: false,
                    length: 100,
                    labelText: local.pleaseWriteOtherDetails,
                    onChanged: (value) {},
                    controller: controller,
                  ),
                  SizedBox(height: constVerticalPadding),
                  Text(
                    local.enterRequestNumber,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: constVerticalPadding),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: grey,
                    ),
                    child: CustomDropDownList(
                      list: items,
                      selectedValue: _selectedType,
                      onChanged: (String? newValue) {
                        setState(() {
                          // Use a null-aware operator to handle null values safely
                          _selectedType = newValue ?? '';
                          modelget.orderNumber = _selectedType;
                          // Provide a default empty string if null
                        });
                      },
                      hint: local.pleaseChooseRequestNumber,
                    ),
                  ),
                  SizedBox(height: constVerticalPadding),
                  Center(
                    child: MainButton(
                      text: local.submitRequest,
                      backGroundColor: primaryColor,
                      onTap: () async {
                        if (_selectedType == null || _selectedType!.isEmpty) {
                          // Show a snackbar or another form of feedback if order number is not selected
                          showSnackBar(context, local.pleaseChooseRequestNumber,
                              redColor);
                        } else {
                          // Proceed with the submission
                          print("wid ${widget.id}");
                          housemodel.orderNumber = _selectedType.toString();

                          housemodel.description = controller.text.isEmpty
                              ? "no description"
                              : controller.text;
                          housemodel.design_id = widget.id.toString();

                          await context
                              .read<FinalOrdersCubit>()
                              .PostSketch(context);
                        }
                      },
                    ),
                  ),
                  if (isLoading) Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

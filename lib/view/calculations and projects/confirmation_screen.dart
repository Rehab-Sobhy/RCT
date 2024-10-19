import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/common%20copounents/custom_textformfield.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/common%20copounents/pop_up.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/model/order_model.dart';
import 'package:rct/shared_pref.dart';
import 'package:rct/view-model/cubits/order/order_cubit.dart';
import 'package:rct/view-model/functions/image_picker.dart';
import 'package:rct/view-model/functions/location_permission.dart';
import 'package:rct/view-model/functions/snackbar.dart';
import 'package:rct/view/google%20maps/pin_location_screen.dart';
import 'package:rct/view/home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({super.key});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  TextEditingController controller = TextEditingController();
  bool isLoading = false;
  dynamic nationalIdImage;
  dynamic electronicImage;
  dynamic landCheckImage; // Optional
  bool isLocationConfirmed = false;
  void showImage(BuildContext context, File image) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Image.file(image),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    OrderModel orderModel = Provider.of<OrderModel>(context, listen: false);
    var local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButtonAppBar(context),
      body: BlocConsumer<OrderCubit, OrderState>(
        listener: (context, state) {
          if (state is OrderLoading) {
            setState(() {
              isLoading = true;
            });
          }
          if (state is OrderFailure) {
            setState(() {
              isLoading = false;
            });
            SchedulerBinding.instance.addPostFrameCallback((_) {
              showSnackBar(context, state.errMessage, Colors.red);
            });
          } else if (state is OrderSuccess) {
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
                  ontap: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (route) => false,
                  ),
                );
              },
            );
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: isLoading,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    local.nationalIdOrCommercialRegister,
                    style: TextStyle(fontSize: 12, color: blackColor),
                  ),
                  SizedBox(height: constVerticalPadding),
                  InkWell(
                    onTap: () => pickImageFromGallery(context).then((value) {
                      if (value != null) {
                        setState(() {
                          nationalIdImage = value;
                          orderModel.nationalidimage = value;
                        });
                      }
                    }),
                    child: nationalIdImage == null
                        ? Image.asset("$imagePath/upload-photo.png")
                        : InkWell(
                            onTap: () => showImage(context, nationalIdImage!),
                            child: Image.file(
                              nationalIdImage!,
                              height: 50,
                              width: 50,
                              fit: BoxFit.fill,
                            ),
                          ),
                  ),
                  SizedBox(height: constVerticalPadding),
                  Text(
                    local.electronicDeed,
                    style: TextStyle(fontSize: 12, color: blackColor),
                  ),
                  SizedBox(height: constVerticalPadding),
                  InkWell(
                    onTap: () => pickImageFromGallery(context).then((value) {
                      if (value != null) {
                        setState(() {
                          electronicImage = value;
                          orderModel.electronicimage = value;
                        });
                      }
                    }),
                    child: electronicImage == null
                        ? Image.asset("$imagePath/upload-photo.png")
                        : InkWell(
                            onTap: () => showImage(context, electronicImage!),
                            child: Image.file(
                              electronicImage!,
                              height: 50,
                              width: 50,
                              fit: BoxFit.fill,
                            ),
                          ),
                  ),
                  SizedBox(height: constVerticalPadding),
                  Text(
                    local.addSoilTestReport,
                    style: TextStyle(fontSize: 12, color: blackColor),
                  ),
                  Text(
                    local.additionalCostIfNotAvailable,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.red,
                          fontWeight: mainFontWeight,
                          fontSize: 12,
                        ),
                  ),
                  SizedBox(height: constVerticalPadding),
                  InkWell(
                    onTap: () => pickImageFromGallery(context).then((value) {
                      if (value != null) {
                        setState(() {
                          landCheckImage = value;
                          orderModel.landCheckImage = value;
                        });
                      } else if (value == "" || value == null) {
                        setState(() {
                          landCheckImage = "no image";
                          orderModel.landCheckImage = "no image";
                        });
                      }
                    }),
                    child: landCheckImage == null
                        ? Image.asset("$imagePath/upload-photo.png")
                        : InkWell(
                            onTap: () => showImage(context, landCheckImage),
                            child: Image.file(
                              landCheckImage,
                              height: 50,
                              width: 50,
                              fit: BoxFit.fill,
                            ),
                          ),
                  ),
                  SizedBox(height: constVerticalPadding),
                  Text(
                    local.propertyLocation,
                    style: TextStyle(fontSize: 12, color: blackColor),
                  ),
                  SizedBox(height: constVerticalPadding),
                  InkWell(
                    onTap: () async {
                      await LocationPermission()
                          .requestLocationPermission()
                          .then(
                              (_) => LocationPermission().getCurrentLocation());
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  PinLocationScreen(
                            onPlacePicked: (p0) {
                              // Ensure valid location data is being returned
                              if (p0 != null && p0.geometry != null) {
                                orderModel.lat =
                                    p0.geometry!.location.lat.toString();
                                orderModel.long =
                                    p0.geometry!.location.lng.toString();
                                orderModel.location = p0.name ?? '';
                                setState(() {
                                  controller.text = orderModel.location ?? '';
                                });

                                // Confirm that data is passed back correctly
                                if (kDebugMode) {
                                  print(
                                      "Location selected: ${orderModel.location}");
                                  print("Latitude: ${orderModel.lat}");
                                  print("Longitude: ${orderModel.long}");
                                }
                              } else {
                                print("Error: Location or geometry is null");
                              }

                              // Close the map screen
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      );
                    },
                    child: Image.asset("$imagePath/Frame 177.png"),
                  ),
                  SizedBox(height: constVerticalPadding),
                  TextFormFieldCustom(
                    context: context,
                    labelText: local.enterSiteLink, // Optional field
                    controller: controller,
                    onChanged: (value) {},
                  ),
                  SizedBox(height: constVerticalPadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        activeColor: primaryColor,
                        value: isLocationConfirmed,
                        onChanged: (value) {
                          setState(() {
                            isLocationConfirmed = value ?? false;
                          });
                        },
                      ),
                      Text(
                        local.confirmlocation,
                        style: TextStyle(fontSize: 12, color: blackColor),
                      ),
                    ],
                  ),
                  SizedBox(height: constVerticalPadding),
                  Center(
                    child: MainButton(
                      text: local.send,
                      backGroundColor: primaryColor,
                      onTap: () async {
                        // Validation for required fields
                        orderModel.buildtype_id =
                            AppPreferences.getData(key: "type");

                        if (electronicImage == null) {
                          showSnackBar(context, "من فضلك ارفع الصك الإلكتروني",
                              redColor);
                          return;
                        }
                        if (nationalIdImage == null) {
                          showSnackBar(
                              context, "من فضلك ارفع الهوية الوطنية", redColor);
                          return;
                        }
                        if (!isLocationConfirmed) {
                          showSnackBar(
                              context, "من فضلك قم بتأكيد الموقع", redColor);
                          return;
                        }
                        setState(() {
                          isLoading = true;
                        });

                        await context.read<OrderCubit>().pushOrder(context);
                      },
                    ),
                  ),
                  SizedBox(height: constVerticalPadding),
                  Center(
                      child: MainButton(
                    text: local.cancelRequest,
                    backGroundColor: grey,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text(
                              "هل انت متأكد من إلغاء الطلب؟",
                              style: TextStyle(fontSize: 12),
                            ),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    // Navigate to HomeScreen and remove all previous routes
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => HomeScreen()),
                                      (route) => false,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        const Color.fromRGBO(52, 168, 83, 1),
                                    elevation: 5,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                  ),
                                  child: const Text(
                                    'نعم',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    // Simply close the dialog without any action
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.red,
                                    elevation: 2,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                  ),
                                  child: const Text(
                                    'لا',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  )),
                  SizedBox(height: constVerticalPadding),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

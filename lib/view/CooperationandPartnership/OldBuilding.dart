import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/common%20copounents/custom_textformfield.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/common%20copounents/pop_up.dart';
import 'package:rct/constants/constants.dart';

import 'package:rct/view-model/functions/image_picker.dart';
import 'package:rct/view-model/functions/location_permission.dart';
import 'package:rct/view-model/functions/snackbar.dart';
import 'package:rct/view/CooperationandPartnership/coopeativestates.dart';
import 'package:rct/view/CooperationandPartnership/cooperativeMdel.dart';
import 'package:rct/view/CooperationandPartnership/cooperative_cubit.dart';
import 'package:rct/view/google%20maps/pin_location_screen.dart';
import 'package:rct/view/home_screen.dart';
import 'package:rct/view/RealEstate/custom_textfield1.dart';

class Oldbuilding_Screen extends StatefulWidget {
  const Oldbuilding_Screen({super.key});

  @override
  State<Oldbuilding_Screen> createState() => _Oldbuilding_ScreenState();
}

final List<String> _cities = [
  'الرياض',
  'جده',
  'المدينه المنوره',
  'تبوك',
  'الدمام',
  'الاحساء',
  'القطيف',
  'خميس مشيط',
  'المظيلف',
  'الهفوف',
  'المبرز',
  'الطائف',
  'نجران',
  'حفر الباطن',
  'الجبيل',
  'ضباء',
  'الخرج',
  'الثقبة',
  'ينبع البحر',
  'الخبر',
  'عرعر',
  'الحوية',
  'عنيزه',
  'سكاكا',
  'جيزان',
  'القريات',
  'الظهران',
  'الباحة',
  'الزلفي',
  'الرس',
  'وادى الدواسر',
  'بيشه',
  'سيهات',
  'شروره',
  'بحره',
  'تاروت',
  'الدوادمى',
  'صبياء',
  'بيش',
  'احد رفيدة',
  'الفريش',
  'بارق',
  'الحوطه',
  'الافلاج'
];

class _Oldbuilding_ScreenState extends State<Oldbuilding_Screen> {
  TextEditingController locationcontroller = TextEditingController();
  String? selectedCity;
  TextEditingController houseTypeController = TextEditingController();

  TextEditingController houseNameController = TextEditingController();
  TextEditingController houseSpaceController = TextEditingController();
  TextEditingController distrectnameController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  bool isLoading = false;
  File? identity;
  File? electronicimage;
  final ImagePicker _picker = ImagePicker();
  bool isLocationConfirmed = false;
  Future<void> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        // Check if the image is for identity or electronic image
        if (identity == null) {
          identity = File(image.path);
        } else {
          electronicimage = File(image.path);
        }
      });
    }
  }

  bool loc = false;
  void _showImage(File image) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Image.file(
          image,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }

  void _validateAndSubmit(
      BuildContext context, CooperativeModel cooperativeModel) async {
    if (identity == null) {
      showSnackBar(context, "من فضلك ارفع الهوية الوطنية", redColor);
      return;
    }
    if (electronicimage == null) {
      showSnackBar(context, "من فضلك ارفع الصك الإلكتروني", redColor);
      return;
    }
    if (priceController.text.isEmpty) {
      showSnackBar(context, "من فضلك أدخل السعر", redColor);
      return;
    }
    if (selectedCity == null || selectedCity!.isEmpty) {
      showSnackBar(context, "من فضلك اختر المدينة", redColor);
      return;
    }
    if (distrectnameController.text.isEmpty) {
      showSnackBar(context, "من فضلك أدخل اسم الحي", redColor);
      return;
    }
    if (loc == false && locationcontroller.text.isEmpty) {
      showSnackBar(context,
          "من فضلك بتحديدالموقع من خلال الخريطة أو إدخال الرابط", redColor);
      return;
    }
    if (!isLocationConfirmed) {
      showSnackBar(context, "من فضلك قم بتأكيد الموقع", redColor);
      return;
    }

    cooperativeModel.price = int.tryParse(priceController.text);
    cooperativeModel.district_name = distrectnameController.text;
    cooperativeModel.city_name = selectedCity;
    cooperativeModel.identity = identity;
    cooperativeModel.electronic_instrument = electronicimage;
    cooperativeModel.location = locationcontroller.text;

    await context.read<CooperativeCubit>().OldBuildingsFunction(context);
  }

  @override
  @override
  Widget build(BuildContext context) {
    CooperativeModel cooperativeModel =
        Provider.of<CooperativeModel>(context, listen: false);
    var local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButtonAppBar(context),
      body: BlocConsumer<CooperativeCubit, Coopeativestates>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is OldBildingsLoadingStates) {
            isLoading = true;
          }
          if (state is OldBildingFailedStates) {
            isLoading = false;
            SchedulerBinding.instance.addPostFrameCallback((_) {
              showSnackBar(context, state.message, Colors.red);
            });
          } else if (state is OldBildingSuccessStates) {
            isLoading = false;
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
                        (route) => false),
                  );
                });
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: isLoading,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      local.nationalIdOrCommercialRegister,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: constVerticalPadding),
                    identity != null
                        ? GestureDetector(
                            onTap: () => _showImage(identity!),
                            child: Image.file(
                              identity!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          )
                        : InkWell(
                            child: Image.asset("$imagePath/upload-photo.png"),
                            onTap: pickImageFromGallery,
                          ),
                    SizedBox(height: constVerticalPadding),
                    Text(
                      local.electronicDeed,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: constVerticalPadding),
                    electronicimage != null
                        ? GestureDetector(
                            onTap: () => _showImage(electronicimage!),
                            child: Image.file(
                              electronicimage!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          )
                        : InkWell(
                            child: Image.asset("$imagePath/upload-photo.png"),
                            onTap: pickImageFromGallery,
                          ),
                    SizedBox(height: constVerticalPadding),
                    Custom_textField(
                      hintText: "",
                      textt: local.price,
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      validator: (value) {},
                    ),
                    SizedBox(height: constVerticalPadding),
                    Text(
                      local.city,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      dropdownColor: Colors.white,
                      value: selectedCity,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 0),
                        ),
                        fillColor: grey.withOpacity(0.5),
                        filled: true,
                        labelStyle:
                            Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: darkGrey,
                                  overflow: TextOverflow.clip,
                                ),
                        hintText: "",
                      ),
                      items: _cities.map((String city) {
                        return DropdownMenuItem<String>(
                          value: city,
                          child: Text(
                            city,
                            style: TextStyle(fontSize: 12),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCity = newValue;
                        });
                      },
                    ),
                    Custom_textField(
                      hintText: local.enterDistrict,
                      textt: local.district,
                      controller: distrectnameController,
                      validator: (value) {},
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: constVerticalPadding),
                    Text(
                      local.propertyLocation,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                      //
                    ),
                    SizedBox(height: constVerticalPadding),
                    InkWell(
                      child: Image.asset("$imagePath/Frame 177.png"),
                      onTap: () async {
                        await LocationPermission()
                            .requestLocationPermission()
                            .then((value) =>
                                LocationPermission().getCurrentLocation());

                        loc = true;
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    PinLocationScreen(
                              onPlacePicked: (p0) {
                                // Ensure valid location data is being returned
                                if (p0 != null && p0.geometry != null) {
                                  cooperativeModel.lat =
                                      p0.geometry!.location.lat.toString();
                                  cooperativeModel.long =
                                      p0.geometry!.location.lng.toString();
                                  cooperativeModel.location = p0.name ?? '';
                                  setState(() {
                                    locationcontroller.text =
                                        cooperativeModel.location ?? '';
                                  });

                                  // Confirm that data is passed back correctly
                                  if (kDebugMode) {
                                    print(
                                        "Location selected: ${cooperativeModel.location}");
                                    print("Latitude: ${cooperativeModel.lat}");
                                    print(
                                        "Longitude: ${cooperativeModel.long}");
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
                    ),
                    SizedBox(height: constVerticalPadding),
                    TextFormFieldCustom(
                      context: context,
                      labelText: local.enterSiteLink,
                      onChanged: (value) {},
                      controller: locationcontroller,
                      // number: true,
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
                          _validateAndSubmit(context, cooperativeModel);
                          if (selectedCity != null &&
                              distrectnameController.text.isNotEmpty &&
                              priceController.text.isNotEmpty &&
                              identity != null &&
                              electronicimage != null) {
                          } else {
                            print("error");
                          }
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
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomeScreen()),
                                            (route) => false,
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: const Color.fromRGBO(
                                              52, 168, 83, 1),
                                          elevation: 5,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 2),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(7),
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
                                            borderRadius:
                                                BorderRadius.circular(7),
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
                          }),
                    ),
                    SizedBox(height: constVerticalPadding),
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

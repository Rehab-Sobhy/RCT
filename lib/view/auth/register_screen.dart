import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:rct/common%20copounents/custom_textformfield.dart';
import 'package:rct/common%20copounents/custom_textformfield_password.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/model/auth/register_model.dart';
import 'package:rct/view/auth/sendotp.dart';
import 'package:rct/view-model/cubits/register/register_cubit.dart';
import 'package:rct/view-model/functions/image_picker.dart';
import 'package:rct/view-model/functions/snackbar.dart';
import 'package:rct/view/auth/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static String id = "RegisterScreen";

  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  File? image;
  String? name;
  @override
  @override
  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context)!;
    final registerModel = Provider.of<RegisterModel>(context);
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          isLoading = true;
        } else if (state is RegisterSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SendOtp()),
            (route) => false,
          );
        } else if (state is RegisterFailed) {
          isLoading = false;
          // Assuming your backend returns the error message in `state.errMessage`
          if (state.errMessage.contains('phone')) {
            showSnackBar(
                context, ' رقم الهاتف غير صحيح او مستخدم مسبقا', redColor);
          } else {
            // Generic error message
            showSnackBar(context, 'حدث خطأ أثناء التسجيل: ${state.errMessage}',
                redColor);
          }
        }
      },
      builder: (context, state) => ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0, scrolledUnderElevation: 0.0,
            centerTitle: true,
            title: Image.asset(
              "assets/images/photo_2024-09-16_00-14-11.jpg",
              fit: BoxFit.contain,
              width: 100,
              height: 100,
            ),
            // backgroundColor: primaryColor,
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SendOtp()));
              },
              icon: Icon(
                Icons.arrow_back_ios_new_sharp,
                color: Colors.black,
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Form(
              key: formKey,
              child: Center(
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        local.createAccount,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: constHorizontalPadding,
                      ),
                      child: TextFormFieldCustom(
                        context: context,
                        controller: nameController,
                        labelText: local.name,
                        onChanged: (value) {
                          registerModel.name = value;
                          name = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: constHorizontalPadding,
                          vertical: constVerticalPadding),
                      child: TextFormFieldCustom(
                        context: context,
                        controller: emailController,
                        labelText: local.email,
                        onChanged: (value) {
                          registerModel.email = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: constHorizontalPadding,
                      ),
                      child: TextFormFieldCustom(
                        Text: "966+",
                        context: context,
                        controller: phonecontroller,
                        labelText: "الهاتف",
                        onChanged: (value) {
                          registerModel.phone = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: constVerticalPadding,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: constHorizontalPadding,
                      ),
                      child: PasswordFormFieldCustom(
                        // context: context,
                        controller: passwordController,
                        labelText: local.password,
                        onChanged: (value) {}, validator: (value) {},
                      ),
                    ),
                    SizedBox(
                      height: constVerticalPadding,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: constHorizontalPadding,
                      ),
                      child: PasswordFormFieldCustom(
                        // context: context,
                        controller: confirmPasswordController,
                        labelText: local.confirmPassword,
                        onChanged: (value) {}, validator: (value) {},
                      ),
                    ),
                    SizedBox(
                      height: constVerticalPadding,
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: constHorizontalPadding,
                        ),
                        child: MainButton(
                          text: local.chooseImage,
                          backGroundColor: darkGrey,
                          width: 500.w,
                          onTap: () {
                            pickImageFromGallery(context).then((value) => {
                                  registerModel.image = value,
                                  image = value,
                                });
                          },
                        )),
                    SizedBox(
                      height: constVerticalPadding,
                    ),
                    Center(
                      child: MainButton(
                          text: local.enter,
                          backGroundColor: primaryColor,
                          onTap: () async {
                            if (nameController.text.isEmpty) {
                              showSnackBar(
                                  context, 'الرجاء إدخال الاسم', redColor);
                              return;
                            }

                            if (emailController.text.isEmpty) {
                              showSnackBar(context,
                                  'الرجاء إدخال البريد الإلكتروني', redColor);
                              return;
                            } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(emailController.text)) {
                              showSnackBar(context,
                                  'الرجاء إدخال بريد إلكتروني صحيح', redColor);
                              return;
                            }

                            if (passwordController.text.isEmpty) {
                              showSnackBar(context, 'الرجاء إدخال كلمة المرور',
                                  redColor);
                              return;
                            }

                            if (confirmPasswordController.text.isEmpty) {
                              showSnackBar(context, 'الرجاء تأكيد كلمة المرور',
                                  redColor);
                              return;
                            }

                            if (passwordController.text !=
                                confirmPasswordController.text) {
                              showSnackBar(context, 'كلمات المرور غير متطابقة',
                                  redColor);
                              return;
                            }

                            if (image == null) {
                              showSnackBar(context, 'الرجاء اختيار صورة الهوية',
                                  redColor);
                              return;
                            }
                            if (phonecontroller.text.isEmpty) {
                              showSnackBar(
                                  context, 'الرجاء إدخال رقم الهاتف', redColor);
                              return;
                            } else if (!RegExp(r'^[0-9]{9}$')
                                .hasMatch(phonecontroller.text)) {
                              showSnackBar(context,
                                  'الرجاء إدخال رقم هاتف صحيح', redColor);
                              return;
                            }

                            // If all validations pass, proceed with the registration
                            registerModel.email = emailController.text;
                            registerModel.password = passwordController.text;
                            registerModel.password_confirmation =
                                confirmPasswordController.text;

                            await BlocProvider.of<RegisterCubit>(context)
                                .signup(registerModel, context);
                          }),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Text.rich(
                        TextSpan(
                          text: local.haveAccount,
                          children: <InlineSpan>[
                            TextSpan(
                              text: local.login,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontSize: 12,
                                    color: Colors.blue,
                                  ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SendOtp())),
                            )
                          ],
                        ),
                      ),
                    ),
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

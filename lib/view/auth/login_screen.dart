import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
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
import 'package:rct/model/auth/login_model.dart';
import 'package:rct/view-model/cubits/login/login_cubit.dart';
import 'package:rct/view-model/functions/snackbar.dart';
import 'package:rct/view/auth/register_screen.dart';
import 'package:rct/view/home_screen.dart';
import 'package:rct/view/RealEstate/notification/notifications_screen.dart';

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  static String id = "LoginScreen";

  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  String? fcmToken;
  void initState() {
    // context.read<FinalOrdersCubit>().Users();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        // context.read<FinalOrdersCubit>().Users();
        // AppPreferences.getData(key: 'myname') ?? 'Default Name';

        // AppPreferences.getData(key: 'myimage') ?? "";

        int notificationId = Random().nextInt(1000000) + 10;
        debugPrint('$notificationId');
        AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: notificationId,
              channelKey: 'local notification key',
              displayOnBackground: true,
              displayOnForeground: true,
              title: message.notification!.title,
              body: message.notification!.body),
        );
      });
    });
    super.initState();
    FirebaseMessaging.onMessageOpenedApp.listen((message) {});
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AwesomeNotifications().setListeners(
          onActionReceivedMethod: (receivedAction) {
        ////here                  Routes.teacherNavbarPageRoute
        return Navigator.push(context,
            MaterialPageRoute(builder: (context) => NotificationScreen()));
      });
      // Ensure a Future<void> is returned
    });
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    firebaseMessaging.getToken().then((token) {
      fcmToken = token;
      print("****************************************");
      print("fcmToken is $fcmToken");

      print("****************************************");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context)!;
    final loginModel = Provider.of<LoginModel>(context);
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          isLoading = true;
        } else if (fcmToken != null && state is LoginSuccess) {
          loginModel.fcm_token = fcmToken!;
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomeScreen()));
        } else if (state is LoginFailed) {
          isLoading = false;
          showSnackBar(context, state.errMessage, redColor);
        }
      },
      builder: (context, state) => ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Form(
              key: formKey,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/header.jpg",
                      fit: BoxFit.contain,
                      height: 50.h,
                      width: 170.w,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      local.login,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
                          loginModel.email = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "الرجاء إدخال البريد الإلكتروني";
                          } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
                              .hasMatch(value)) {
                            return "صيغة البريد الإلكتروني غير صحيحة";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: constHorizontalPadding,
                      ),
                      child: PasswordFormFieldCustom(
                        controller: passwordController,
                        labelText: local.password,
                        onChanged: (value) {
                          loginModel.password = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "الرجاء إدخال كلمة المرور";
                          } else if (value.length < 8) {
                            return "يجب أن تكون كلمة المرور مكونة من 8 أحرف على الأقل";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: constVerticalPadding,
                    ),
                    MainButton(
                      text: local.enter,
                      backGroundColor: primaryColor,
                      onTap: () async {
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
                          showSnackBar(
                              context, 'الرجاء إدخال كلمة المرور', redColor);
                          return;
                        }
                        if (formKey.currentState!.validate()) {
                          loginModel.fcm_token = fcmToken!;
                          await BlocProvider.of<LoginCubit>(context)
                              .login(loginModel, context);
                        }
                      },
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Text.rich(
                        TextSpan(
                          text: local.doNotHaveAccount,
                          children: <InlineSpan>[
                            TextSpan(
                                text: local.createAccount,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: Colors.blue, fontSize: 12),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterScreen()),
                                      )),
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

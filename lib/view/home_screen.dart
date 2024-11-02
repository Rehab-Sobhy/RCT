import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/common%20copounents/pop_up.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/model/order_model.dart';
import 'package:rct/view-model/functions/check_token.dart';
import 'package:rct/view/auth/sendotp.dart';
import 'package:rct/view/calculations%20and%20projects/measurment_of%20_villa.dart';
import 'package:rct/view/favorite/main_favourite.dart';
import 'package:rct/shared_pref.dart';
import 'package:rct/view/aboutUs.dart';
import 'package:rct/view/final_orders/final-orders.dart';
import 'package:rct/main.dart';
import 'package:rct/view/CooperationandPartnership/choose_building_type.dart';
import 'package:rct/view/RealEstate/final_offers.dart';

import 'package:rct/view/calculations%20and%20projects/measurment_of_field_screen.dart';
import 'package:rct/view/designs%20and%20sketches/designs_and_screen.dart';
import 'package:rct/view/auth/edit_profile_screen.dart';
import 'package:rct/view/final_orders/final_orders_cubit.dart';
import 'package:rct/view/final_orders/final_orders_states.dart';
import 'package:rct/view/notification/notifications_screen.dart';
import 'package:rct/view/partener_success/partners_screen.dart';
import 'package:rct/view/privacy_screen.dart';
import 'package:rct/view/terms_conditions_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeScreen extends StatefulWidget {
  static String id = "HomeScreen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = "";
  dynamic number;
  dynamic image;
  double hight = 130;
  String whatsapUrl = "https://wa.me/+966569988788";
  String emailUrl = "support@apprct.info";
  String twitterLink = "https://x.com/rctapplication";
  void initState() {
    context.read<FinalOrdersCubit>().Users();
    _loadNameandiamge();
    getnotifyNumber();
    checkLoginStatus();
    _checkLoginStatus();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        int notificationId = Random().nextInt(1000000) + 10;
        debugPrint('$notificationId');
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: notificationId,
            channelKey: 'local notification key',
            displayOnBackground: true,
            displayOnForeground: true,
            title: message.notification!.title,
            body: message.notification!.body,
          ),
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
      deviceToken = token;
    });
    super.initState();
  }

  Future<void> _loadNameandiamge() async {
    setState(() {
      name = AppPreferences.getData(key: 'myname') ?? 'Default Name';

      image = AppPreferences.getData(key: 'myimage') ??
          'https://images.app.goo.gl/nZvnQQ58zj1YKVNu9'; // Provide a default name if none is saved
    });
  }

  Future<void> getnotifyNumber() async {
    setState(() {
      number = AppPreferences.getData(key: 'notifyLenghth') ?? 0;

      // Provide a default name if none is saved
    });
  }

  bool loged = false;
  Future<void> _checkLoginStatus() async {
    bool isLoggedIn = await checkLoginStatus();
    print(",,,,,,,,,, $isLoggedIn");
    setState(() {
      loged = isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    OrderModel orderModel = Provider.of<OrderModel>(context, listen: false);
    var local = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (BuildContext context) => InkWell(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Image.asset(
                "$iconsPath/drawer-icon.png",
              ),
            ),
            onTap: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(local.welcome,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        actions: [
          InkWell(
            onTap: () {
              setState(() {
                number = 0; // Reset notification count
              });
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
            child: loged
                ? Stack(
                    children: [
                      Icon(
                        number == 0 || number == "" || number == null
                            ? Icons.notifications_none
                            : Icons.notifications,
                        color: whiteBackGround,
                      ),
                      if (number != 0 && number != "" && number != null)
                        Positioned(
                          right: 2,
                          top: 1,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: const BoxConstraints(minWidth: 6),
                            // child: Text(
                            //   "$number", // Ensure the number is a string
                            //   style: const TextStyle(
                            //     color: Colors.white,
                            //     fontSize:
                            //         4, // Adjusted the font size for visibility
                            //   ),
                            //   textAlign: TextAlign.center,
                            // ),
                          ),
                        ),
                    ],
                  )
                : Container(),
          ),
          SizedBox(width: 10.w),
        ],
      ),
      drawer: Drawer(
        backgroundColor: whiteBackGround,
        surfaceTintColor: whiteBackGround,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.w, top: 50.h, bottom: 20.h),
              child: BlocConsumer<FinalOrdersCubit, FinalOrdersStates>(
                listener: (context, state) {
                  if (state is UserSucess) {
                    setState(() {
                      name = state.users.first.name!;
                      image = "$linkServerName/${state.users.first.image}";
                    });
                  } else if (state is UserFaild) {
                    setState(() {
                      name = 'Default Name';
                      image = 'https://example.com/default-image.png';
                    });
                  }
                },
                builder: (context, state) {
                  if (state is UserLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return loged
                      ? ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(image),
                            radius: 40,
                          ),
                          title: Text(
                            name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                          ),
                          subtitle: InkWell(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EditProfileScreen()),
                            ),
                            child: Text(
                              local.editFile,
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 13,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.blue,
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => SendOtp()),
                              );
                            },
                            child: Text(
                              local.login,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                },
              ),
            ),
            loged == true
                ? Column(
                    children: [
                      ListTile(
                        title: Text(
                          local.orders,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                        leading: SvgPicture.asset(
                          "$iconsPath/1.svg",
                          color: Colors.black,
                        ),
                        // titleTextStyle: Theme.of(context).textTheme.titleMedium,
                        onTap: () {
                          print("inhome$loginToken");
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const FinalOrdersScreen()));
                        },
                      ),
                      const Divider(),
                      ListTile(
                        title: Text(
                          local.favorites,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        leading: SvgPicture.asset("$iconsPath/2.svg"),
                        // titleTextStyle: Theme.of(context).textTheme.titleMedium,
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => MainFavourites())),
                      ),
                    ],
                  )
                : Container(),
            const Divider(),
            ListTile(
              title: Text(
                local.aboutUs,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              leading: SvgPicture.asset("$iconsPath/3.svg"),
              // titleTextStyle: Theme.of(context).textTheme.titleMedium,
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AboutUsScreen())),
            ),
            const Divider(),
            ListTile(
              title: Text(
                local.privacyPolicy,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              leading: SvgPicture.asset("$iconsPath/Vector.svg"),
              // titleTextStyle: Theme.of(context).textTheme.titleMedium,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const PrivacysScreen())),
            ),
            const Divider(),
            ListTile(
              title: Text(
                local.termsConditions,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              leading: SvgPicture.asset("$iconsPath/Vector-1.svg"),
              // titleTextStyle: Theme.of(context).textTheme.titleMedium,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const TermsAndConditionsScreen())),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    child: Image.asset(
                      "$iconsPath/icons8-whatsapp-50 (1).png",
                      width: 30.w,
                      height: 30.h,
                    ),
                    onTap: () async {
                      await launchUrlString(whatsapUrl);
                    },
                  ),
                  InkWell(
                    child: const Icon(
                      Icons.email,
                      size: 30,
                      color: Colors.black,
                    ),
                    onTap: () {
                      launchEmail(emailUrl);
                    },
                  ),
                  InkWell(
                    child: Image.asset(
                      "$iconsPath/icons8-twitter-50 (1).png",
                      width: 30.w,
                      height: 30.h,
                    ),
                    onTap: () async {
                      await launchUrlString(twitterLink);
                    },
                  ),
                ],
              ),
            ),
            // const Divider(),
            // ListTile(
            //   leading: const Icon(
            //     Icons.language,
            //   ),
            //   title: Text(
            //     local.language,
            //     style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            //   ),
            //   // titleTextStyle: Theme.of(context).textTheme.titleMedium,
            //   onTap: () {
            //     Navigator.of(context).push(MaterialPageRoute(
            //         builder: (context) => const LanguageScreen()));
            //   },
            // ),

            loged
                ? Column(
                    children: [
                      const Divider(),
                      ListTile(
                        title: Text(
                          local.logout,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                        leading: SvgPicture.asset("$iconsPath/Vector-4.svg"),
                        // titleTextStyle: Theme.of(context).textTheme.titleMedium,
                        onTap: () async {
                          await secureStorage.deleteAll();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                          // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                        },
                      ),
                    ],
                  )
                : Container(),
            const Divider(),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(
                        30,
                      ),
                      bottomLeft: Radius.circular(
                        30,
                      )),
                  color: primaryColor),
            ),
          ),
          Positioned.fill(
            top: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      "$iconsPath/logo_without_text-icon.png",
                      height: 130.h,
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          InkWell(
                            onTap: () async {
                              // If logged in, navigate to the ChooseBuildingType screen
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ChooseBuildingType(),
                                ),
                              );
                            },
                            child: SizedBox(
                              height:
                                  hight, // Ensure 'height' is correctly defined
                              child: Card(
                                color: whiteBackGround,
                                margin: const EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: ListTile(
                                    title: Text(
                                      local.cooperationAndPartnership,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    leading: Image.asset(
                                      "assets/images/CooperationandPartnership.png",
                                      width: 50.w,
                                    ),
                                    trailing: const Icon(
                                        Icons.arrow_forward_ios_rounded),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          InkWell(
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const FinalOffers(
                                          url: linkHouses,
                                        ))),
                            child: SizedBox(
                              height: hight,
                              child: Card(
                                color: whiteBackGround,
                                margin: const EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: ListTile(
                                    title: Text(
                                      local.realestate,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    leading: Image.asset(
                                      "assets/images/cuate.png",
                                      width: 50,
                                    ),
                                    trailing: const Icon(
                                        Icons.arrow_forward_ios_rounded),
                                  ),
                                ),
                              ),
                            ),
                          ),

// Replace with actual logic to check if the user is logged in

                          SizedBox(
                            height: hight,
                            child: Card(
                              color: whiteBackGround,
                              margin: const EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: ListTile(
                                    title: Text(
                                      local.calculatorProjects,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    leading: Image.asset(
                                      "$iconsPath/projectsAndCalc-icon.png",
                                      width: 50,
                                    ),
                                    trailing: const Icon(
                                        Icons.arrow_forward_ios_rounded),
                                    onTap: () async {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            contentPadding: EdgeInsets.all(20),
                                            backgroundColor: Colors.white,
                                            title: const Center(
                                              child: Text(
                                                "الرجاء اختيار آلية البناء",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            content: Container(
                                              width: double.infinity,
                                              height: 90,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    width: 100,
                                                    child: MainButton(
                                                      text: "مجمع سكني",
                                                      textColor: Colors.white,
                                                      backGroundColor:
                                                          primaryColor,
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pop(); // Close first dialog
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return ShowPopUp(
                                                              ontap: () async {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              title: const Text(
                                                                "يرجى التواصل مع فريق RCT لإتمام طلبك.",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                              content: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  const Text(
                                                                    "للتواصل عبر واتساب",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            10),
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          20),
                                                                  InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      await launchUrlString(
                                                                          whatsapUrl
                                                                              .toString());
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          25,
                                                                      child: Image
                                                                          .asset(
                                                                        "assets/images/watsap.png",
                                                                        fit: BoxFit
                                                                            .fill,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 60,
                                                    child: MainButton(
                                                        text: "ڤلل",
                                                        textColor: Colors.white,
                                                        backGroundColor:
                                                            primaryColor,
                                                        onTap: () async {
                                                          String loginMessage =
                                                              "يرجى تسجيل الدخول ."; // Custom message
                                                          bool isLoggedIn =
                                                              await checkLoginStatus(); // Check if the user is logged in

                                                          if (isLoggedIn) {
                                                            // If logged in, navigate to the ChooseBuildingType screen
                                                            orderModel
                                                                    .main_type =
                                                                "ڤلل";
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.of(
                                                                    context)
                                                                .push(
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const MeasurmentOfVilla(),
                                                              ),
                                                            );
                                                          } else {
                                                            // Show dialog if the user is not logged in
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      "تنبيه",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    content:
                                                                        Text(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      loginMessage,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              109,
                                                                              106,
                                                                              106)),
                                                                    ), // Display the login message
                                                                    actions: [
                                                                      Row(
                                                                        children: [
                                                                          TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop(); // Close the dialog
                                                                            },
                                                                            child:
                                                                                const Text(
                                                                              "إلغاء",
                                                                              style: TextStyle(fontSize: 12, color: Colors.black),
                                                                            ),
                                                                          ),
                                                                          Spacer(),
                                                                          TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop(); // Close the dialog
                                                                              // Navigate to the login screen
                                                                              Navigator.pushReplacement(
                                                                                context,
                                                                                MaterialPageRoute(builder: (context) => SendOtp()), // Replace with your actual login screen
                                                                              );
                                                                            },
                                                                            child:
                                                                                const Text(
                                                                              "تسجيل الدخول",
                                                                              style: TextStyle(fontSize: 12, color: Colors.black),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  );
                                                                });
                                                          }
                                                        }),
                                                  ),
                                                  Container(
                                                    width: 60,
                                                    child: MainButton(
                                                        text: "عمائر",
                                                        textColor: Colors.white,
                                                        backGroundColor:
                                                            primaryColor,
                                                        onTap: () async {
                                                          String loginMessage =
                                                              "يرجى تسجيل الدخول ."; // Custom message
                                                          bool isLoggedIn =
                                                              await checkLoginStatus(); // Check if the user is logged in

                                                          if (isLoggedIn) {
                                                            // If logged in, navigate to the ChooseBuildingType screen
                                                            "عمائر";
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.of(
                                                                    context)
                                                                .push(
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const MeasurmentOfFieldScreen(),
                                                              ),
                                                            );
                                                          } else {
                                                            // Show dialog if the user is not logged in
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      "تنبيه",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    content:
                                                                        Text(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      loginMessage,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              109,
                                                                              106,
                                                                              106)),
                                                                    ), // Display the login message
                                                                    actions: [
                                                                      Row(
                                                                        children: [
                                                                          TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop(); // Close the dialog
                                                                            },
                                                                            child:
                                                                                const Text(
                                                                              "إلغاء",
                                                                              style: TextStyle(fontSize: 12, color: Colors.black),
                                                                            ),
                                                                          ),
                                                                          Spacer(),
                                                                          TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop(); // Close the dialog
                                                                              // Navigate to the login screen
                                                                              Navigator.pushReplacement(
                                                                                context,
                                                                                MaterialPageRoute(builder: (context) => SendOtp()), // Replace with your actual login screen
                                                                              );
                                                                            },
                                                                            child:
                                                                                const Text(
                                                                              "تسجيل الدخول",
                                                                              style: TextStyle(fontSize: 12, color: Colors.black),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  );
                                                                });
                                                          }
                                                        }),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              // If logged in, navigate to the DesignAndScreen
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const DesignAndScreen(),
                                ),
                              );
                            },
                            child: SizedBox(
                              height:
                                  hight, // Ensure 'height' is correctly defined
                              child: Card(
                                color: whiteBackGround,
                                margin: const EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: ListTile(
                                    title: Text(
                                      local.plansDesigns,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    leading: Image.asset(
                                      "$iconsPath/rafiki.png",
                                      width: 50,
                                    ),
                                    trailing: const Icon(
                                        Icons.arrow_forward_ios_rounded),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2

                          InkWell(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PartnersScreen())),
                            child: SizedBox(
                              height: hight,
                              child: Card(
                                color: whiteBackGround,
                                margin: const EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: ListTile(
                                    title: Text(
                                      local.successPartners,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    leading: Image.asset(
                                      "$iconsPath/rafiki2.png",
                                      width: 50.w,
                                    ),
                                    trailing: const Icon(
                                        Icons.arrow_forward_ios_rounded),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          //عملاء وشراكة***************************************
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

bool? isLoggedIn;

// Function to check login status
Future<bool> checkLoginStatus() async {
  isLoggedIn =
      await Checktoken().hasToken(); // Ensure Checktoken is correctly defined
  return isLoggedIn ?? false; // Return false if isLoggedIn is null
}

void launchEmail(String email) async {
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: email,
    queryParameters: {
      'subject': 'Your Subject Here',
      'body': 'Your email body here',
    },
  );

  await launchUrl(emailUri);
}

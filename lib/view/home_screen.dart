import 'dart:io';
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
import 'package:rct/model/order_model.dart';
import 'package:rct/view/calculations%20and%20projects/measurment_of%20_villa.dart';

import 'package:rct/view/favorite/main_favourite.dart';
import 'package:rct/shared_pref.dart';

import 'package:rct/view/aboutUs.dart';
import 'package:rct/view/favorite/favorite.dart';
import 'package:rct/view/final_orders/final-orders.dart';
import 'package:rct/main.dart';
import 'package:rct/view/CooperationandPartnership/choose_building_type.dart';
import 'package:rct/view/RealEstate/final_offers.dart';
import 'package:rct/view/auth/login_screen.dart';
import 'package:rct/view/calculations%20and%20projects/measurment_of_field_screen.dart';
import 'package:rct/view/designs%20and%20sketches/designs_and_screen.dart';
import 'package:rct/view/auth/edit_profile_screen.dart';
import 'package:rct/view/final_orders/final_orders_cubit.dart';
import 'package:rct/view/final_orders/final_orders_states.dart';
import 'package:rct/view/language_screen.dart';
import 'package:rct/view/RealEstate/notification/notifications_screen.dart';
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

Future<String?> _getname() async {
  return AppPreferences.getData(key: 'name');
}

Future<File?> _getimage() async {
  return AppPreferences.getData(key: 'image');
}

class _HomeScreenState extends State<HomeScreen> {
  String name = "";
  dynamic image;
  double hight = 130.h;
  String whatsapUrl = "https://wa.me/+966569988788";
  String emailUrl = "support@apprct.info";
  String twitterLink = "https://x.com/rctapplication";
  void initState() {
    context.read<FinalOrdersCubit>().Users();
    _loadNameandiamge();
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
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NotificationScreen())),
            child: Icon(
              Icons.notifications_none,
              color: whiteBackGround,
            ),
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
              padding: EdgeInsets.only(
                left: 10.w,
                top: 50.h,
                bottom: 20.h,
              ),
              child: BlocConsumer<FinalOrdersCubit, FinalOrdersStates>(
                listener: (BuildContext context, state) {
                  if (state is UserSucess) {
                    setState(() {
                      name = state.users.first
                          .name!; // Use data directly from Cubit state
                      image = "$linkServerName/${state.users.first.image}";
                    });
                  } else if (state is UserFaild) {
                    // Handle failures or provide default values
                    setState(() {
                      name = 'Default Name';
                      image = 'https://example.com/default-image.png';
                    });
                  }
                },
                builder: (BuildContext context, Object? state) {
                  if (state is UserLoading) {
                    return Center(
                        child:
                            CircularProgressIndicator()); // Show loading indicator
                  }
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(image),
                        radius: 40,
                      ),
                      title: Text(
                        name,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                      ),
                      subtitle: InkWell(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const EditProfileScreen())),
                        child: Text(
                          local.editFile,
                          style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 13,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.blue),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            ListTile(
              title: Text(
                local.orders,
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
              leading: SvgPicture.asset("$iconsPath/1.svg"),
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
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              leading: SvgPicture.asset("$iconsPath/2.svg"),
              // titleTextStyle: Theme.of(context).textTheme.titleMedium,
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MainFavourites())),
            ),
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
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.language,
              ),
              title: Text(
                local.language,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              // titleTextStyle: Theme.of(context).textTheme.titleMedium,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LanguageScreen()));
              },
            ),
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
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
                // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
            ),
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
                borderRadius: BorderRadius.circular(30),
                color: primaryColor,
              ),
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
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ChooseBuildingType())),
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
                                      local.cooperationAndPartnership,
                                      style: TextStyle(
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
                                    width: 50.w,
                                  ),
                                  trailing: const Icon(
                                      Icons.arrow_forward_ios_rounded),
                                  onTap: () => showDialog(
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
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        content: Container(
                                          width: double.infinity,
                                          height: 90,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 100,
                                                child: MainButton(
                                                  text: "مجمع سكني",
                                                  textColor: Colors.white,
                                                  backGroundColor: primaryColor,
                                                  onTap: () {
                                                    // Close the first dialog before showing the next one
                                                    Navigator.of(context).pop();

                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return ShowPopUp(
                                                          ontap: () async {
                                                            await launch(
                                                                whatsapUrl
                                                                    .toString());
                                                          },
                                                          title: const Text(
                                                            "يرجى التواصل مع فريق RCT لإتمام طلبك.",
                                                            style: TextStyle(
                                                                fontSize: 10),
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
                                                                  width: 20),
                                                              InkWell(
                                                                onTap:
                                                                    () async {
                                                                  await launch(
                                                                      whatsapUrl
                                                                          .toString());
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 40,
                                                                  width: 40,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                  child: Image
                                                                      .asset(
                                                                    "assets/images/Group 469324.png",
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
                                                  backGroundColor: primaryColor,
                                                  onTap: () {
                                                    orderModel.main_type =
                                                        "ڤلل";
                                                    // Close the first dialog before navigating
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const MeasurmentOfVilla(),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              Container(
                                                width: 60,
                                                child: MainButton(
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                  text: "عمائر",
                                                  textColor: Colors.white,
                                                  backGroundColor: primaryColor,
                                                  onTap: () {
                                                    orderModel.main_type =
                                                        "عمائر";
                                                    // Close the first dialog before navigating
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const MeasurmentOfFieldScreen(),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const DesignAndScreen())),
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
                                      local.plansDesigns,
                                      style: TextStyle(
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

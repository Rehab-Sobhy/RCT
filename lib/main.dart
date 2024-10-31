import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:rct/common%20copounents/locale_provider.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/model/auth/login_model.dart';
import 'package:rct/model/auth/register_model.dart';
import 'package:rct/model/build_types_model.dart';
import 'package:rct/model/complex_model.dart';
import 'package:rct/model/designs_order_model.dart';
import 'package:rct/model/order_model.dart';
import 'package:rct/model/receipts_model.dart';
import 'package:rct/shared_pref.dart';
import 'package:rct/splash.dart';
import 'package:rct/view-model/cubits/build_types_and_floors/build_types_and_floors_cubit.dart';
import 'package:rct/view-model/cubits/complex/complex_cubit.dart';
import 'package:rct/view-model/cubits/designs/designs_cubit.dart';
import 'package:rct/view-model/cubits/order%20number/order_number_cubit.dart';
import 'package:rct/view-model/cubits/order/order_cubit.dart';
import 'package:rct/view-model/cubits/orders%20list/orders_list_cubit.dart';
import 'package:rct/view-model/cubits/preferable/preferable_cubit.dart';
import 'package:rct/view-model/cubits/receipts/receipts_cubit.dart';
import 'package:rct/view-model/cubits/register/register_cubit.dart';
import 'package:rct/view-model/cubits/sketches/sketches_cubit.dart';
import 'package:rct/view-model/cubits/types/types_cubit.dart';
import 'package:rct/view/CooperationandPartnership/cooperativeMdel.dart';
import 'package:rct/view/CooperationandPartnership/cooperative_cubit.dart';
import 'package:rct/view/RealEstate/bloc_helper.dart';
import 'package:rct/view/RealEstate/modelget.dart';
import 'package:rct/view/notification/notification-detaails2.dart';
import 'package:rct/view/notification/notifycubit.dart';
import 'package:rct/view/final_orders/final_orders_cubit.dart';
import 'package:rct/view/RealEstate/model.dart';
import 'package:rct/view/RealEstate/post_cubit.dart';
import 'package:rct/view/RealEstate/real_estate_cubit.dart';
import 'package:rct/view/final_orders/orders_screen.dart';
import 'package:rct/view/onboarding/onboarding_screen_1.dart';
import 'package:rct/view/partener_success/cubit.dart';
import 'firebase_options.dart';

late FlutterSecureStorage secureStorage;

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  secureStorage = const FlutterSecureStorage();
  AwesomeNotifications().initialize(
    "resource://drawable/test",
    [
      NotificationChannel(
        channelKey: 'local notification key',
        channelName: 'local notification channel name',
        channelDescription: 'local notification channel description',
        playSound: true,
        vibrationPattern: highVibrationPattern,
        importance: NotificationImportance.Max,
        onlyAlertOnce: true,
        defaultPrivacy: NotificationPrivacy.Private,
        channelShowBadge: true,
        // Optional: add custom sound if neededflutter build appbundle --release

        // soundSource: 'resource://raw/sound',
      ),
      NotificationChannel(
        channelKey: 'local notification key back',
        channelName: 'local notification channel name back',
        channelDescription: 'local notification channel description back',
        playSound: true,
        vibrationPattern: highVibrationPattern,
        importance: NotificationImportance.Max,
        onlyAlertOnce: true,
        defaultPrivacy: NotificationPrivacy.Private,
        channelShowBadge: true,
        // Optional: add custom sound if needed
        // soundSource: 'resource://raw/sound',
      ),
    ],
    debug: true,
  );

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  NotificationSettings settings = await firebaseMessaging.requestPermission();
  FirebaseMessaging.onBackgroundMessage(_handlePushNotifications);
  firebaseMessaging.setForegroundNotificationPresentationOptions(
    sound: true,
    alert: true,
    badge: true,
  );

  AppPreferences.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginModel>(
          create: (_) => LoginModel(),
        ),
        ChangeNotifierProvider<RegisterModel>(
          create: (_) => RegisterModel(),
        ),
        ChangeNotifierProvider<OrderModel>(
          create: (_) => OrderModel(),
        ),
        ChangeNotifierProvider<HouseModel>(
          create: (_) => HouseModel(),
        ),
        ChangeNotifierProvider<BuildTypesModel>(
          create: (_) => BuildTypesModel(),
        ),
        ChangeNotifierProvider<LocaleProvider>(
          create: (_) => LocaleProvider(),
        ),
        ChangeNotifierProvider<DesignsOrderModel>(
          create: (_) => DesignsOrderModel(),
        ),
        ChangeNotifierProvider<ComplexModel>(
          create: (_) => ComplexModel(),
        ),
        ChangeNotifierProvider<ReceiptsModel>(
          create: (_) => ReceiptsModel(),
        ),
        ChangeNotifierProvider<OrderModel>(
          create: (_) => OrderModel(),
        ),
        ChangeNotifierProvider<CooperativeModel>(
          create: (_) => CooperativeModel(),
        ),
        ChangeNotifierProvider<NotificationDetails222>(
          create: (_) => NotificationDetails222(),
        ),
        ChangeNotifierProvider<Modelget>(
          create: (_) => Modelget(),
        ),
      ],
      child: const ScreenUtilInit(
        designSize: Size(393, 852),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    return MultiBlocProvider(
      providers: [
        //NotificationCubit
        BlocProvider(
          create: (context) => NotificationCubit(),
        ),
        // BlocProvider(
        //   create: (context) => LoginCubit(),
        // ),
        BlocProvider(
          create: (context) => RegisterCubit(),
        ),
        BlocProvider(
          create: (context) => SketchesCubit(),
        ),
        BlocProvider(
          create: (context) => FinalOrdersCubit(),
        ),
        BlocProvider(
          create: (context) => DesignsCubit(),
        ),
        BlocProvider(
          create: (context) => TypesCubit(),
        ),
        BlocProvider(
          create: (context) => OrderNumberCubit(),
        ),
        BlocProvider(
          create: (context) => BuildTypesAndFloorsCubit(),
        ),
        BlocProvider(
          create: (context) => OrderCubit(),
        ),
        BlocProvider(
          create: (context) => HouseCubit(),
        ),
        BlocProvider(
          create: (context) => PreferableCubit(),
        ),
        BlocProvider(
          create: (context) => ComplexCubit(),
        ),
        BlocProvider(
          create: (context) => ReceiptsCubit(),
        ),
        BlocProvider(
          create: (context) => CooperativeCubit(),
        ),
        BlocProvider(
          create: (context) => OrdersListCubit()..fetchOrderList(),
          child: const OrderListScreen(),
        ),
        BlocProvider<DataCubit>(
          create: (context) => DataCubit(),
        ),
        BlocProvider<ParetenerCubit>(
          create: (context) => ParetenerCubit(),
        ),
        BlocProvider<NotificationCubit>(
          create: (context) => NotificationCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'RCT App',
        theme: ThemeData(
          brightness: Brightness.light,
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          checkboxTheme: CheckboxThemeData(
            checkColor: WidgetStatePropertyAll(Colors.white),
          ),
          fontFamily: 'Font1',
          primaryColor: primaryColor,
          indicatorColor: primaryColor,
          textTheme: TextTheme(),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.id,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: provider.locale,
        home: OnboardingScreen(),
      ),
    );
  }
}

Future<void> _handlePushNotifications(RemoteMessage message) async {}

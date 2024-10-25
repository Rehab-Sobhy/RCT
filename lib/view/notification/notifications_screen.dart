import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/shared_pref.dart';
import 'package:rct/view/notification/download.dart';
import 'package:rct/view/final_orders/final-orders.dart';
import 'package:rct/view/final_orders/orders_screen.dart';
import 'package:rct/view/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/view/notification/notifycubit.dart';
import 'package:rct/view/notification/states.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool hasNavigated = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<NotificationCubit>(context)
          .fetchData("https://rctapp.com/api/all-notifications");
      print("Fetching notifications...");
    });
  }

  Future<void> _setButtonPressed(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notification_$id', false);
  }

  Future<bool> _checkIfButtonPressed(String id) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('notification_$id') ?? true;
  }

  String _getNotificationType(String type) {
    switch (type) {
      case "rawland":
        return "ارض خام";
      case "oldbuilding":
        return "مباني قديمة";
      case "formschema":
        return "مخططات";
      case "houses":
        return "العروض العقارية";
      case "orders":
        return "الحاسبة والمشاريع";
      default:
        return " ";
    }
  }

  bool isLoading = false;
  dynamic id;
  bool flag = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButtonAppBar(context),
      body: BlocConsumer<NotificationCubit, NotificationState>(
          builder: (context, state) {
        if (state is NotificationLoading) {
          return Center(child: Container());
        } else if (state is NotificationLoaded) {
          if (state.notifications.isEmpty) {
            return Center(child: Text('''You don't have notifications'''));
          } else {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0, top: 10),
              child: ListView.builder(
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];
                  final data = notification.notification.data;

                  id = notification.id.toString();
                  AppPreferences.saveData(
                      key: "notifyLenghth", value: state.notifications.length);
                  return FutureBuilder<bool>(
                    future: _checkIfButtonPressed(notification.id.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      bool showButton = snapshot.data ?? true;

                      return Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                        child: IntrinsicHeight(
                          child: Container(
                            // height:
                            //     notification.notification.title == "New Update"
                            //         ? 110
                            //         : !showButton
                            //             ? 150
                            //             : MediaQuery.of(context).size.height * .3,
                            child: Card(
                              elevation: 0,
                              color: Color.fromRGBO(151, 163, 169, 0.2),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    right: 15, left: 15, top: 10, bottom: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      style: TextStyle(fontSize: 12),
                                      notification.notification.title,
                                      maxLines: 3,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          style: TextStyle(fontSize: 10),
                                          _getNotificationType(
                                              notification.notification.type),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      style: TextStyle(fontSize: 14),
                                      "${notification.notification.message}",
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 1),
                                      child: notification.notification.type !=
                                              "order_pay"
                                          ? Center(
                                              child: (showButton &&
                                                      notification.notification
                                                              .title !=
                                                          "New Update")
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              await context
                                                                  .read<
                                                                      NotificationCubit>()
                                                                  .postNotify(
                                                                    agreed_terms:
                                                                        1,
                                                                    type: notification
                                                                        .notification
                                                                        .type,
                                                                    data_id: notification
                                                                        .notification
                                                                        .data
                                                                        .id,
                                                                  );

                                                              setState(() {
                                                                flag = true;
                                                                showButton =
                                                                    false;
                                                              });

                                                              await _setButtonPressed(
                                                                  notification
                                                                      .id
                                                                      .toString());
                                                            },
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              foregroundColor:
                                                                  Colors.white,
                                                              backgroundColor:
                                                                  const Color
                                                                      .fromRGBO(
                                                                      52,
                                                                      168,
                                                                      83,
                                                                      1),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          40,
                                                                      vertical:
                                                                          6),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            7),
                                                              ),
                                                            ),
                                                            child: const Text(
                                                              'قبول',
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 15),

                                                          ///************************ */
                                                          ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              setState(() {
                                                                showButton =
                                                                    false;
                                                              });
                                                              await _setButtonPressed(
                                                                  notification
                                                                      .id
                                                                      .toString());
                                                              await context
                                                                  .read<
                                                                      NotificationCubit>()
                                                                  .postNotify(
                                                                    agreed_terms:
                                                                        0,
                                                                    type: notification
                                                                        .notification
                                                                        .type,
                                                                    data_id: notification
                                                                        .notification
                                                                        .data
                                                                        .id,
                                                                  );
                                                            },
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              foregroundColor:
                                                                  Colors.white,
                                                              backgroundColor:
                                                                  Colors.red,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          40,
                                                                      vertical:
                                                                          6),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            7),
                                                              ),
                                                            ),
                                                            child: const Text(
                                                              'رفض',
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Container(),
                                            )
                                          : (notification.notification.type! ==
                                                      "order_pay" &&
                                                  notification
                                                          .notification.title !=
                                                      "New Update")
                                              ? Center(
                                                  child: Container(
                                                    width: double.infinity,
                                                    child: showButton
                                                        ? ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              setState(() {
                                                                showButton =
                                                                    false; // Start loading
                                                              });

                                                              await _setButtonPressed(
                                                                  notification
                                                                      .id
                                                                      .toString());

                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            FinalOrdersScreen()),
                                                              );

                                                              setState(() {
                                                                isLoading =
                                                                    false; // Stop loading
                                                              });
                                                            },
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              foregroundColor:
                                                                  Colors.white,
                                                              backgroundColor:
                                                                  primaryColor,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          40,
                                                                      vertical:
                                                                          6),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            7),
                                                              ),
                                                            ),
                                                            child: isLoading
                                                                ? Container()
                                                                : const Text(
                                                                    'الانتقال الى الدفع',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                          )
                                                        : Container(),
                                                  ),
                                                )
                                              : Container(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }
        } else {
          return Center(child: Text("You don't have Notifications"));
        }
      }, listener: (context, state) {
        if (state is NotificationLoaded && flag == true && !hasNavigated) {
          hasNavigated = true;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DownloadScreen(
                NotificationId: id,
              ),
            ),
          ).then((_) {
            // Reset the flag to prevent repeated navigation
            setState(() {
              flag = false;
              hasNavigated = false;
            });
          });
        }
      }),
    );
  }
}

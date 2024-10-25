import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/common%20copounents/pop_up.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/view-model/functions/image_picker.dart';
import 'package:rct/view-model/functions/snackbar.dart';
import 'package:rct/view/notification/notify_model.dart';
import 'package:rct/view/notification/notifycubit.dart';
import 'package:rct/view/notification/states.dart';
import 'package:rct/view/home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DownloadScreen extends StatefulWidget {
  final String? NotificationId;

  DownloadScreen({super.key, required this.NotificationId});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  File? identity;
  bool isLocked = false;
  bool isLoading = false;
  bool _isDownloading = false;
  String _downloadProgress = "0%";
  bool _isChecked = false; // Checkbox state

  // Function to download file

  Future<void> _downloadFile(String url, String fileName) async {
    setState(() {
      _isDownloading = true;
    });

    try {
      if (Platform.isAndroid) {
        var status = await Permission.storage.request();
        if (!status.isGranted) {
          throw Exception('Storage permission is not granted.');
        }
      }

      // تحديد المسار إلى مجلد التنزيلات على Android
      String savePath;

      if (Platform.isAndroid) {
        // الحصول على مسار مجلد التنزيلات
        Directory? downloadsDir = Directory('/storage/emulated/0/Download');
        savePath = "${downloadsDir.path}/$fileName";
      } else if (Platform.isIOS) {
        Directory docsDir = await getApplicationDocumentsDirectory();
        savePath = "${docsDir.path}/$fileName";
      } else {
        throw Exception('Unsupported platform');
      }

      print("Saving file to: $savePath");

      Dio dio = Dio();

      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _downloadProgress =
                  "${(received / total * 100).toStringAsFixed(0)}%";
            });
          }
        },
      );

      setState(() {
        _isDownloading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("File saved successfully at $savePath"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _isDownloading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Download failed: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String? fileName;

  // Future<void> _downloadFileee(String fullUrl) async {
  //   // Generate a unique filename using  the current timestamp
  //   String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
  //   fileName = "RCT_$timestamp.pdf";

  //   // Your download logic here
  //   // For example:
  //   final response = await Dio().download(fullUrl, '/path/to/save/$fileName');

  //   if (response.statusCode == 200) {
  //     print('File downloaded: $fileName');
  //   } else {
  //     print('Download failed: ${response.statusCode}');
  //   }
  // }

  bool lol = false;

  @override
  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButtonAppBar(context),
      body: BlocConsumer<NotificationCubit, NotificationState>(
        builder: (BuildContext context, Object? state) {
          List<NotificationModel> getdata =
              context.read<NotificationCubit>().allDataList;
          final product = getdata.firstWhere(
            (element) => element.id == widget.NotificationId,
          );

          print("iddd ${product.id}");
          return ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150,
                        child: InkWell(
                          onTap: () {
                            final String? fileUrl = product.file;
                            const String baseUrl =
                                "https://rctapp.com"; // Replace with your base URL
                            String? fullUrl;
                            if (fileUrl != null && fileUrl.isNotEmpty) {
                              fullUrl = Uri.parse(baseUrl)
                                  .resolve(fileUrl)
                                  .toString();
                            }

                            if (fullUrl != null &&
                                Uri.tryParse(fullUrl)?.hasAbsolutePath ==
                                    true) {
                              _downloadFile(fullUrl, " RCT.pdf");
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Invalid or missing file URL.")),
                              );
                            }
                          },
                          child: _isDownloading
                              ? Center(
                                  child:
                                      Text('Downloading... $_downloadProgress'))
                              : Image.network(
                                  "https://th.bing.com/th/id/OIP.VUEgQLuoZq5Dr_xhkOpi2gHaHa?rs=1&pid=ImgDetMain",
                                  fit: BoxFit.fill,
                                ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "الرجاء  تحميل المرفق",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(height: constVerticalPadding),
                    // InkWell(
                    //   child: identity != null
                    //       ? Image.file(
                    //           identity!,
                    //           height: 50,
                    //           width: 50, // Set a proper height for the image
                    //           fit: BoxFit.cover, // Adjust the image fit
                    //         )
                    //       : Image.asset(
                    //           "$imagePath/upload-photo.png", // Default image when no image is selected
                    //           height: 150, // Set a height for consistency
                    //         ),
                    //   onTap: () => pickImageFromGallery(context)
                    //       .then((value) => setState(() {
                    //             if (value != null) {
                    //               identity = value; // Assign the picked image
                    //             }
                    //           })),
                    // ),

                    InkWell(
                      onTap: () => pickImageFromGallery(context).then((value) {
                        if (value != null) {
                          setState(() {
                            identity = value;
                          });
                        }
                      }),
                      child: isLocked
                          ? Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    // Show the image in a dialog when clicked
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.file(
                                                identity!,
                                                fit: BoxFit.cover,
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Close'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Image.file(
                                    identity!,
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Spacer(),
                                IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    // Unlock the image and show the text field again
                                    setState(() {
                                      isLocked = false;
                                      identity = null;
                                    });
                                  },
                                ),
                              ],
                            )
                          : InkWell(
                              onTap: () =>
                                  pickImageFromGallery(context).then((value) {
                                if (value != null) {
                                  setState(() {
                                    identity = value;

                                    isLocked =
                                        true; // Lock the image when selected
                                  });
                                }
                              }),
                              child: Image.asset("$imagePath/upload-photo.png"),
                            ),
                    ),

                    SizedBox(height: constVerticalPadding),
                    CheckboxListTile(
                      title: const Text(
                        "لقد قرأت الشروط والأحكام و أوافق عليها",
                        style: TextStyle(fontSize: 14),
                      ),
                      value: _isChecked,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _isChecked =
                              newValue ?? false; // Update checkbox state
                        });
                      },
                      controlAffinity: ListTileControlAffinity
                          .leading, // Checkbox on the left side
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_isChecked) {
                              await context
                                  .read<NotificationCubit>()
                                  .postNotify(
                                    file: identity,
                                    agreed_terms: 1,
                                    type: product.notification.type,
                                    data_id: product.notification.data.id,
                                  );
                              print(
                                  "data_id ${product.notification.data.id}  type: ${product.notification.type} file $identity");
                              lol = true;

                              // print(
                              //     "${product.notification.data.id + product.notification.type + identity}");
                            } else {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text("You have Rejected terms"),
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: primaryColor,
                            elevation: 2,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          child: const Text(
                            'قبول',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_isChecked) {
                              await context
                                  .read<NotificationCubit>()
                                  .postNotify(
                                    file: identity,
                                    agreed_terms: 0,
                                    type: product.notification.type,
                                    data_id: product.notification.data.id,
                                  );
                              print(
                                  "data_id ${product.notification.data.id}  type: ${product.notification.type} file $identity");

                              lol = true;
                            } else {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text("You have Rejected terms"),
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.grey,
                            elevation: 2,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          child: const Text(
                            'رفض',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is NotificationLoading) {
            setState(() {
              isLoading = true;
            });
          }
          if (state is NotificationError) {
            setState(() {
              isLoading = false;
            });
            showSnackBar(
                context, state.message, const Color.fromARGB(255, 32, 31, 31));
          } else if (state is NotificationLoaded && lol == true) {
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
                      // title: Text(local.requestSentSuccessfully),
                      title: Text("تم إرسال ردك بنجاح شكرا لك"),
                    ),
                    ontap: () {
                      // Close the current dialog
                      Navigator.of(context, rootNavigator: true).pop();

                      // Navigate to the NotificationScreen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    });
              },
            );
          }
        },
      ),
    );
  }
}

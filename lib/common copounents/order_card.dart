// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:rct/constants/constants.dart';
// import 'package:rct/view-model/functions/compare_date.dart';
// import 'package:url_launcher/url_launcher.dart';

// class OrderCard extends StatelessWidget {
//   final Map order;

//   const OrderCard({Key? key, required this.order}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var local = AppLocalizations.of(context)!;

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8.0),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 1,
//               blurRadius: 5,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   _buildOrderInfo(context, local.orderNumber, order['number']),
//                   _buildOrderInfo(context, local.status, order['status'],
//                       status: true),
//                   _buildOrderInfo(context, local.date,
//                       timeDifferenceFromNow(order['created_at'])),
//                 ],
//               ),
//               const SizedBox(height: 12.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     width: 300,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: primaryColor,
//                           foregroundColor: Colors.white),
//                       onPressed: () =>
//                           _handlePayment(context, order['id'].toString()),
//                       child: Text("ادفع الآن"),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {},
//                     child: Icon(
//                       Icons.upload,
//                       color: primaryColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildOrderInfo(BuildContext context, String label, String value,
//       {bool status = false}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: Theme.of(context)
//               .textTheme
//               .bodySmall!
//               .copyWith(color: Colors.grey),
//         ),
//         const SizedBox(height: 4.0),
//         status
//             ? Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//                 decoration: BoxDecoration(
//                   color: _getStatusColor(value),
//                   borderRadius: BorderRadius.circular(12.0),
//                 ),
//                 child: Text(
//                   value,
//                   style: Theme.of(context)
//                       .textTheme
//                       .bodySmall!
//                       .copyWith(color: Colors.white),
//                 ),
//               )
//             : Text(
//                 value,
//                 style: Theme.of(context).textTheme.bodyMedium,
//               ),
//       ],
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case "accepted" || "approved" || "approve":
//         return Colors.green;
//       case 'canceled':
//         return Colors.red;
//       case 'pending':
//       default:
//         return Colors.amber;
//     }
//   }

//   Future<void> _handlePayment(BuildContext context, String orderId) async {
//     try {
//       var dio = Dio();
//       var response = await dio.get('https://rctapp.com/api/pay/$orderId');
//       var data = response.data;

//       // Access the 'status' and 'redirect_url' from the response data
//       String? status = data['status'] as String?;
//       String? paymentUrl = data['data']?['redirect_url'] as String?;

//       if (status == 'success' && paymentUrl != null) {
//         await launch(paymentUrl);
//       } else {
//         _showErrorDialog(context, 'لم يتم تحديد التكلفة');
//       }
//     } catch (e) {
//       _showErrorDialog(context, "لم يتم تحديد التكلفة'");
//     }
//   }

//   void _showErrorDialog(BuildContext context, String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('خطأ'),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('موافق'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }import 'dart:io';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/shared_pref.dart';
import 'package:rct/view-model/functions/compare_date.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderCard extends StatelessWidget {
  final Map order;

  const OrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildOrderInfo(context, local.orderNumber, order['number']),
                  _buildOrderInfo(context, local.status, order['status'],
                      status: true),
                  _buildOrderInfo(context, local.date,
                      timeDifferenceFromNow(order['created_at'])),
                ],
              ),
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () =>
                          _handlePayment(context, order['id'].toString()),
                      child: Text("ادفع الآن"),
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                        _pickAndUploadFile(context, order['number'].toString()),
                    child: Column(
                      children: [
                        Icon(
                          Icons.upload,
                          color: primaryColor,
                        ),
                        Text(
                          "رفع إيصال الدفع",
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderInfo(BuildContext context, String label, String value,
      {bool status = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: Colors.grey),
        ),
        const SizedBox(height: 4.0),
        status
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: _getStatusColor(value),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  value,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.white),
                ),
              )
            : Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "accepted":
      case "approved":
      case "approve":
        return Colors.green;
      case 'canceled':
        return Colors.red;
      case 'pending':
      default:
        return Colors.amber;
    }
  }

  Future<void> _handlePayment(BuildContext context, String orderId) async {
    try {
      var dio = Dio();
      var response = await dio.get('https://rctapp.com/api/pay/$orderId');
      var data = response.data;

      String? status = data['status'] as String?;
      String? paymentUrl = data['data']?['redirect_url'] as String?;

      if (status == 'success' && paymentUrl != null) {
        await launch(paymentUrl);
      } else {
        _showErrorDialog(context, 'لم يتم تحديد التكلفة');
      }
    } catch (e) {
      _showErrorDialog(context, 'لم يتم تحديد التكلفة');
    }
  }

  Future<void> _pickAndUploadFile(
      BuildContext context, String orderNumber) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        print("Picked file path: ${file.path}");
        await _uploadFile(context, file, orderNumber);
      } else {
        _showErrorDialog(context, 'لم يتم اختيار الملف');
      }
    } catch (e) {
      _showErrorDialog(context, 'فشل في اختيار الملف');
      print('Error picking file: $e');
    }
  }

  Future<void> _uploadFile(
      BuildContext context, File file, String orderNumber) async {
    final token = await _getAuthToken();
    try {
      var dio = Dio();

      // Adding headers for the request
      var options = Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
          'Authorization': 'Bearer $token',
        },
      );

      FormData formData = FormData.fromMap({
        'description': orderNumber.toString(),
        'file': await MultipartFile.fromFile(file.path,
            filename: file.path.split('/').last),
      });

      var response = await dio.post('https://rctapp.com/api/receipts',
          data: formData, options: options);

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'تم رفع الملف بنجاح',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ));
      } else {
        print('Response status code: ${response.statusCode}');
        print('Response data: ${response.data}');
        _showErrorDialog(context, 'فشل في رفع الملف');
      }
    } catch (e) {
      print('Error during file upload: $e');
      _showErrorDialog(context, 'حدث خطأ أثناء رفع الملف');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('خطأ'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('موافق'),
            ),
          ],
        );
      },
    );
  }
}

Future<String?> _getAuthToken() async {
  return AppPreferences.getData(key: 'loginToken');
}

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/view/home_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  OtpVerificationScreen({required this.phoneNumber});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  Dio _dio = Dio();

  // Function to validate OTP
  Future<void> _validateOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _dio.post(
        'https://rctapp.com/api/validate-otp',
        data: {
          'phone': widget.phoneNumber,
          'otp': _otpController.text,
        },
      );
      print(response.data);
      // Handle the response accordingly
      if (response.statusCode == 200) {
        print(response.data);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP validated successfully!')),
        );
        // Navigate to the home screen on success
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP validation failed')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to validate OTP')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  //Function to resend OTP
  Future<void> _resendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _dio.post(
        'https://rctapp.com/api/resend-otp',
        data: {'phone': widget.phoneNumber},
        options: Options(
          // Only treat status codes less than 500 as successful responses
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        print(response.data);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP sent successfully!')),
        );
        // Navigate to the OTP verification screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              phoneNumber: widget.phoneNumber,
            ),
          ),
        );
      } else {
        // If status code is other than 200, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to send OTP. Error: ${response.statusCode}')),
        );
      }
    } on DioError catch (e) {
      // Handle Dio exceptions (network issues, timeout, etc.)
      if (e.response != null && e.response!.statusCode == 500) {
        // Server-side error (500 status code)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error: Please try again later.')),
        );
      } else {
        // Handle other types of DioErrors (connection timeout, etc.)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: ${e.message}')),
        );
      }
    } catch (e) {
      // Handle any other errors that might occur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Future<void> _resendOtp() async {
  //   if (!_formKey.currentState!.validate()) return;

  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     final response = await _dio.post(
  //       'https://rctapp.com/api/resend-otp',
  //       data: {'phone': widget.phoneNumber},
  //     );
  //     print(response);
  //     // Handle the response accordingly
  //     if (response.statusCode == 200) {
  //       await (response.data);
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text('OTP sent successfully!')));
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Failed to send OTP')));
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButtonAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 30),
              Text(
                'تأكيد رقم الجوال',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'تم إرسال رمز التحقق إلى الرقم المنتهي ب ${widget.phoneNumber.substring(widget.phoneNumber.length - 3)}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              PinCodeTextField(
                enablePinAutofill: true,
                appContext: context,
                length: 6,
                controller: _otpController,
                keyboardType: TextInputType.number,
                enableActiveFill: true,
                pinTheme: PinTheme(
                  // shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),

                  // Box decoration when the field is not focused/active
                  fieldHeight: 50,
                  fieldWidth: 40,
                  inactiveFillColor: Colors.grey[200]!,
                  inactiveColor:
                      Colors.grey, // Border color for non-active fields

                  // Box decoration when the field is focused/active
                  activeFillColor: const Color.fromARGB(237, 160, 236, 224),
                ),

                onChanged: (value) {
                  // Handle OTP changes
                },

                // Optional validation logic
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the OTP';
                  }
                  return null;
                },
              ),
              SizedBox(height: 40),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : MainButton(
                      backGroundColor: primaryColor,
                      textColor: Colors.white,
                      onTap: _validateOtp,
                      text: 'تسجيل الدخول',
                    ),
              SizedBox(height: 20),
              Text(
                "لم يصلك رمز التحقق ؟",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Image.asset(
                    "assets/images/Vector.png",
                    height: 20,
                    width: 20,
                  ),
                  TextButton(
                    onPressed: _resendOtp, // Call resend OTP function
                    child: Text(
                      'إعادة إرسال رمز التحقق',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
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
}

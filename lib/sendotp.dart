import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/view/auth/register_screen.dart';
import 'package:rct/view/auth/resendotp.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SendOtp extends StatefulWidget {
  @override
  _SendOtpState createState() => _SendOtpState();
}

class _SendOtpState extends State<SendOtp> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  Dio _dio = Dio();

  // Function to validate Saudi Arabian phone number
  String? _validateSaudiPhoneNumber(String phoneNumber) {
    // Regex for Saudi phone numbers: +966 or 05 followed by 8 digits
    // final regex = RegExp(r"^(?:\+966|05)\d{8}$");
    // if (!regex.hasMatch(phoneNumber)) {
    //   return 'صيغة الرقم غير صحيحة';
    // }
    return null;
  }

  // Function to handle OTP request
  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _dio.post(
        'https://rctapp.com/api/resend-otp',
        data: {'phone': _phoneController.text},
        options: Options(
          // Only treat status codes less than 500 as successful responses
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        print(response.data);

        // Success: OTP sent successfully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP sent successfully!')),
        );
        // Navigate to the OTP verification screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              phoneNumber: _phoneController.text,
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

  @override
  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context)!;
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
              SizedBox(height: 50),
              Text(
                'تسجيل الدخول',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'سجل الدخول من خلال رقم الجوال',
                style: TextStyle(fontSize: 10, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'رقم الجوال',
                  labelStyle:
                      TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        20), // Adjust the radius as needed
                    borderSide: BorderSide(
                      color: Colors.grey, // Border color
                      width: 1.0, // Border width
                    ),
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال رقم الجوال';
                  } else if (_validateSaudiPhoneNumber(value) != null) {
                    return 'صيغة الرقم غير صحيحة'; // Arabic error message
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
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          _sendOtp();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OtpVerificationScreen(
                                phoneNumber: _phoneController.text,
                              ),
                            ),
                          );
                        }
                      },
                      text: 'تسجيل الدخول',
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
                                      builder: (context) => RegisterScreen()),
                                )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

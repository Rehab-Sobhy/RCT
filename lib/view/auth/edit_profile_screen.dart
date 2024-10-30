import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart'; // Add image_picker package
import 'package:rct/common%20copounents/custom_textformfield.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/shared_pref.dart';
import 'package:rct/view/home_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final Dio _dio = Dio();
  XFile? _image; // For storing the selected image
  bool _isLoading = false; // Loading indicator

  @override
  void initState() {
    super.initState();
    Users(); // Fetch user data from the API
  }

  // Function to fetch user data from API
  Future<void> Users() async {
    final token = await _getAuthToken();
    print('Auth Token: $token'); // Check token

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _dio.get(
        "https://rctapp.com/api/user",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data is Map) {
        var responseData = response.data;
        print('API Response: $responseData');

        // Handle valid response data
        _nameController.text = responseData["name"] ?? '';
        _emailController.text = responseData["email"] ?? '';
        _phoneController.text = responseData["phone"] ?? '';
      } else {
        print('Unexpected response format: ${response.data}');
      }
    } on DioError catch (e) {
      print(
          'Dio error! STATUS: ${e.response?.statusCode}, DATA: ${e.response?.data}');
    } catch (e) {
      print('Unexpected error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String?> _getAuthToken() async {
    return AppPreferences.getData(key: 'loginToken');
  }

  Future<void> _selectImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image; // Store the selected image
    });
  }

  Future<void> _updateProfile() async {
    final token = await _getAuthToken();

    // Create a Map for the JSON data
    final Map<String, dynamic> userData = {
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      // You can include the profile image URL or file path if needed
      // 'profile_image': _image?.path,
    };

    setState(() {
      _isLoading = true;
    });

    try {
      // Send the data as JSON instead of FormData
      final response = await _dio.put(
        "https://rctapp.com/api/users",
        data: userData, // Send the map as JSON
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json', // Ensure it's JSON
          },
          followRedirects: true,
          validateStatus: (status) {
            return status! < 500; // Accept all statuses below 500
          },
        ),
      );

      if (response.statusCode == 200) {
        print(response);
        // Successfully updated profile
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
        );
      } else {
        print('Failed to update profile: ${response.data}');
      }
    } on DioError catch (e) {
      print(
          'Dio error! STATUS: ${e.response?.statusCode}, DATA: ${e.response?.data}');
    } catch (e) {
      print('Unexpected error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double higt = MediaQuery.of(context).size.height * .05;
    var local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: whiteBackGround,
          ),
        ),
        title: Text(
          local.profile,
          style: TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: -25,
            left: 0,
            right: 0,
            height: 300,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30)),
                color: primaryColor,
              ),
            ),
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(), // Show loading indicator
            )
          else
            Positioned.fill(
              top: higt,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        "assets/images/h512-removebg-preview.png",
                        height: 150.h,
                      ),
                      SizedBox(height: 20.h),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: ListView(
                            children: [
                              Text(
                                local.name,
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(height: 10.h),
                              TextFormFieldCustom(
                                context: context,
                                labelText: _nameController.text.isNotEmpty
                                    ? _nameController.text
                                    : local.name,
                                controller: _nameController,
                                onChanged: (value) {},
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                local.email,
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(height: 10.h),
                              TextFormFieldCustom(
                                context: context,
                                labelText: _emailController.text.isNotEmpty
                                    ? _emailController.text
                                    : local.email,
                                controller: _emailController,
                                onChanged: (value) {},
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                local.phone,
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(height: 10.h),
                              TextFormFieldCustom(
                                context: context,
                                labelText: _phoneController.text.isNotEmpty
                                    ? _phoneController.text
                                    : local.phone,
                                controller: _phoneController,
                                onChanged: (value) {},
                              ),
                              SizedBox(height: 20.h),
                              // Image Selection Button
                              InkWell(
                                onTap: _selectImage,
                                child: Container(
                                  height: 40,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      "تحديد صورة",
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.h),
                              MainButton(
                                text: local.save,
                                backGroundColor: primaryColor,
                                onTap: () {
                                  // Call the update profile method
                                  _updateProfile();
                                },
                              ),
                            ],
                          ),
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

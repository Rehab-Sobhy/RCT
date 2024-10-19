import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rct/common%20copounents/custom_textformfield.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/main.dart';
import 'package:rct/view/home_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    String name = await secureStorage.read(key: 'name') ?? '';
    String email = await secureStorage.read(key: 'email') ?? '';
    String password = await secureStorage.read(key: 'password') ?? '';
    setState(() {
      _nameController.text = name;
      _emailController.text = email;
      _passcontroller.text = password;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          style: TextStyle(color: Colors.white, fontSize: 12),
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
                borderRadius: BorderRadius.circular(30),
                color: primaryColor,
              ),
            ),
          ),
          Positioned.fill(
            top: 10,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        "$iconsPath/logo_without_text-icon.png",
                        height: 100.h,
                      ),
                      SizedBox(height: constVerticalPadding * 5),
                      Text(
                        local.name,
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(height: constVerticalPadding),
                      TextFormFieldCustom(
                        context: context,
                        labelText: local.enterYourName,
                        onChanged: (value) {},
                        controller: _nameController,
                      ),
                      SizedBox(height: constVerticalPadding),
                      Text(
                        local.email,
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(height: constVerticalPadding),
                      TextFormFieldCustom(
                        context: context,
                        labelText: local.enterEmail,
                        onChanged: (value) {},
                        controller: _emailController,
                      ),
                      SizedBox(height: constVerticalPadding),
                      Text(
                        local.password,
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(height: constVerticalPadding),
                      TextFormFieldCustom(
                        context: context,
                        labelText: local.password,
                        onChanged: (value) {},
                        controller: _passcontroller,
                      ),
                      SizedBox(height: constVerticalPadding),
                      MainButton(
                        text: local.save,
                        backGroundColor: primaryColor,
                        onTap: () {
                          // Save the updated name back to secure storage
                          secureStorage.write(
                              key: 'name', value: _nameController.text);
                          secureStorage.write(
                              key: 'password', value: _passcontroller.text);

                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()),
                              (route) => false);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

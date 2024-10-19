import 'package:flutter/material.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';

class name extends StatelessWidget {
  static String id = "name";
  const name({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackButtonAppBar(context),
    );
  }
}

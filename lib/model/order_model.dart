import 'dart:io';
import 'dart:math';
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';

class OrderModel extends ChangeNotifier {
  dynamic streetDetails;
  dynamic main_type;
  dynamic typePrice;
  dynamic finalForm;
  dynamic cost = 0.0;
  dynamic floorcount;
  dynamic lat = "";
  dynamic long = "";
  dynamic location = "";
  dynamic status = "pending";
  dynamic agreement = "yes";
  dynamic landCheckImage;
  late File? electronicimage;
  late File? nationalidimage;
  late dynamic number;
  dynamic user_id = 0;
  dynamic areaspace_id = 0;
  double areaspace = 0.0;
  dynamic type_id = 0;
  dynamic design_id = 0;
  dynamic sketch_id = 0;
  dynamic preferable_id = 0;
  dynamic receipt_id = 0;
  dynamic build_types_price = 0;
  dynamic build_price = 0;
  dynamic SwimmingPool = 0;
  dynamic has_pool;
  dynamic image;
  dynamic buildtype_id;
  dynamic orderNumber;
  List floorDetails = [];
  List<String> orderNumbers = [];

  OrderModel() {
    number = generateRandomNumber().toString();
  }

  int generateRandomNumber() {
    final random = Random();
    return random.nextInt(10000) +
        1; // nextInt(10000) generates a number between 0 and 9999, so we add 1 to get a range from 1 to 10000
  }
}

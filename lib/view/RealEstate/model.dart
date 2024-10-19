// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'dart:math';
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';

class HouseModel extends ChangeNotifier {
  double cost = 0.0;
  dynamic lat = "";
  dynamic long = "";
  dynamic location = "";
  dynamic status = "";
  dynamic orderNumber;
  dynamic agreement = "yes";
  dynamic image1;
  dynamic image;
  dynamic image2;
  dynamic image3;
  dynamic image4;

  late File? electronic_instrument;
  int? house_space;
  int? price;
  dynamic? city_name;
  dynamic? house_type;
  dynamic? house_name;
  dynamic? district_name;
  dynamic description;
  File? identity;
  late dynamic number;
  int user_id = 0;
  int areaspace_id = 0;
  double areaspace = 0.0;
  int type_id = 0;
  dynamic design_id;
  int sketch_id = 0;
  int preferable_id = 0;
  int receipt_id = 0;
  int build_types_price = 0;
  int build_price = 0;
  List floorDetails = [];
  List<dynamic> orderNumbers = [];

  HouseModel() {
    number = generateRandomNumber().toString();
  }

  int generateRandomNumber() {
    final random = Random();
    return random.nextInt(10000) +
        1; // nextInt(10000) generates a number between 0 and 9999, so we add 1 to get a range from 1 to 10000
  }
}

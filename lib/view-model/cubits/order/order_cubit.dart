import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rct/model/order_model.dart';
import 'package:rct/shared_pref.dart';
import 'package:rct/view-model/services/crud.dart';
part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderInitial());
  final Crud _crud = Crud();
  Future<String?> _getAuthToken() async {
    return AppPreferences.getData(key: 'loginToken');
  }

  Future<void> pushOrder(BuildContext context) async {
    final token = await _getAuthToken();

    OrderModel orderModel = Provider.of<OrderModel>(context, listen: false);

    if (!_validateOrder(orderModel)) {
      emit(OrderFailure(errMessage: "Please fill in all required fields."));
      return;
    }

    emit(OrderLoading());

    Map<String, File?> images = {
      'nationalidimage': orderModel.nationalidimage,
      'electronicimage': orderModel.electronicimage,
      'landcheckimage': orderModel.landCheckImage,
    };

    try {
      // String token = await _getBearerToken();

      var result = await _crud.postRequestWithFiles(
        'https://rctapp.com/api/orders', // Updated URL
        {
          "build_id": orderModel.type_id,
          "location": orderModel.location,
          "lat": orderModel.lat,
          "lng": orderModel.long,
          "status": orderModel.status,
          "agreement": orderModel.agreement,
          "number": orderModel.number,
          "cost": orderModel.cost,
          "area": orderModel.areaspace,
          "has_pool": orderModel.has_pool,
          "buildtype_id": orderModel.buildtype_id,
          "user_id": "35",
          "floorcount": orderModel.floorcount,
          "main_type": orderModel.main_type,
        },
        images,
        headers: {
          'Content-Type': 'multipart/form-data',
          'Authorization': 'Bearer $token',
        },
      );

      if (result.containsKey("data")) {
        print("Order Data: ${result['data']}");

        // Check if 'data' is empty
        if (result['data'].isEmpty) {
          emit(OrderFailure(errMessage: "No order numbers found."));
        } else {
          emit(OrderSuccess());
        }
      } else {
        print("Error Response: $result");
        emit(OrderFailure(
            errMessage: "Failed to upload order. Please try again."));
      }
    } catch (e) {
      print("Exception: $e");
      emit(OrderFailure(errMessage: "An error occurred: $e"));
    }
  }

  bool _validateOrder(OrderModel orderModel) {
    return orderModel.type_id != null &&
        orderModel.location != null &&
        orderModel.lat != null &&
        orderModel.long != null &&
        orderModel.status != null &&
        orderModel.agreement != null &&
        orderModel.number != null &&
        orderModel.nationalidimage != null &&
        orderModel.electronicimage != null &&
        orderModel.landCheckImage != null;
  }
}

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/shared_pref.dart';
import 'package:rct/view-model/services/crud.dart';
import 'package:rct/view/RealEstate/model.dart';
import 'package:rct/view/RealEstate/modelget.dart';
import 'package:rct/view/final_orders/final_orders_states.dart';

class FinalOrdersCubit extends Cubit<FinalOrdersStates> {
  FinalOrdersCubit() : super(InitialFinalOrderStates());
  final Crud _crud = Crud();
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  Dio get dio => _dio;
  List<Modelget> realList = [];
  List<String> imageList = []; // Static list to store images
  List<String> nameList = [];
  List<Modelget> rowlandList = [];
  List<Modelget> designs_Sketches = [];
  List<Modelget> users = [];

  Future<void> RealOrders() async {
    emit(RealEstateOrdersLoading());
    final token = await _getAuthToken();

    try {
      final response = await _dio.get(
        "https://rctapp.com/api/user/houses",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // print('Response status: ${response.statusCode}');
      // print('Full response: ${response.data}');

      if (response.statusCode == 200) {
        try {
          var responseData = response.data;
          var houses = responseData['houses'];

          if (houses == null || houses.isEmpty) {
            emit(RealEstateOrdersFaild('''You Do'nt have orders'''));
            return;
          }

          realList = houses
              .map<Modelget>((element) => Modelget.fromJson(element))
              .toList();

          if (realList.isEmpty) {
            emit(RealEstateOrdersFaild('''You Do'nt have orders'''));
          } else {
            emit(RealEstateOrdersSuccess(realList));
          }
        } catch (e) {
          emit(RealEstateOrdersFaild('Failed to decode houses data'));
        }
      } else {
        emit(RealEstateOrdersFaild(
            'Failed to load data. Status code: ${response.statusCode}'));
      }
    } on DioError catch (e) {
      emit(RealEstateOrdersFaild(
          'Dio error! STATUS: ${e.response?.statusCode}, DATA: ${e.response?.data}, HEADERS: ${e.response?.headers}'));
    } catch (e) {
      emit(RealEstateOrdersFaild('Unexpected error: $e'));
    }
  }

  Future<void> RawLand() async {
    emit(RawLandOrdersLoading());
    final token = await _getAuthToken();

    try {
      final response = await _dio.get(
        "https://rctapp.com/api/user/rawlands",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        var responseData = response.data;

        if (responseData is Map<String, dynamic>) {
          var data = responseData['rawLands'] ?? [];
          if (data is List) {
            rowlandList = data
                .map<Modelget>((element) => Modelget.fromJson(element))
                .toList();
            emit(RawLandOrdersSuccess(rowlandList));
          } else {
            emit(RawLandOrdersFaild(
                'Unexpected data type: ${data.runtimeType}'));
          }
        } else if (responseData is List) {
          rowlandList = responseData
              .map<Modelget>((element) => Modelget.fromJson(element))
              .toList();
          emit(RawLandOrdersSuccess(rowlandList));
        } else {
          emit(RawLandOrdersFaild('Invalid JSON structure'));
        }
      } else {
        emit(RawLandOrdersFaild(
            'Failed to load data. Status code: ${response.statusCode}'));
      }
    } catch (e) {
      emit(RawLandOrdersFaild('Error: ${e.toString()}'));
    }
  }

  Future<void> DesignsAndScketches() async {
    emit(DesignsLoading());
    final token = await _getAuthToken();

    try {
      final response = await _dio.get(
        "https://rctapp.com/api/design-and-sketches",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Secure token management
          },
        ),
      );

      if (response.statusCode == 200) {
        var responseData = response.data;
        print('API Response for designs : ${response.data}');
        if (responseData is Map<String, dynamic>) {
          // Extract designs, sketches, and preferables from the response
          var designsData = responseData['designs']?['data'] ?? [];
          var sketchesData = responseData['sketches']?['data'] ?? [];
          var preferablesData = responseData['preferables']?['data'] ?? [];

          List<Modelget> allData = [];

          // Check and convert each list
          if (designsData is List) {
            var designs = designsData
                .map<Modelget>((element) => Modelget.fromJson(element))
                .toList();
            allData.addAll(designs);
          } else {
            emit(DesignsFaild(
                'Unexpected data type for designs: ${designsData.runtimeType}'));
          }

          if (sketchesData is List) {
            var sketches = sketchesData
                .map<Modelget>((element) => Modelget.fromJson(element))
                .toList();
            allData.addAll(sketches);
          } else {
            emit(DesignsFaild(
                'Unexpected data type for sketches: ${sketchesData.runtimeType}'));
          }

          if (preferablesData is List) {
            var preferables = preferablesData
                .map<Modelget>((element) => Modelget.fromJson(element))
                .toList();
            allData.addAll(preferables);
          } else {
            emit(DesignsFaild(
                'Unexpected data type for preferables: ${preferablesData.runtimeType}'));
          }

          if (allData.isNotEmpty) {
            emit(DesignsSuccess(allData));
          } else {
            emit(DesignsFaild('No data available'));
          }
        } else {
          emit(DesignsFaild('Invalid JSON structure'));
        }
      } else {
        emit(DesignsFaild(
            'Failed to load data. Status code: ${response.statusCode}'));
      }
    } catch (e) {
      emit(DesignsFaild('Error: ${e.toString()}'));
    }
  }

  Future<void> PostDes(BuildContext context) async {
    Modelget modelget = Provider.of<Modelget>(context, listen: false);
    HouseModel houseModel = Provider.of<HouseModel>(context, listen: false);
    emit(DesignsLoading());

    try {
      print("Description: ${houseModel.description}");
      print("Order Number: ${houseModel.orderNumber}");
      print("Order Number: ${houseModel.design_id}");
      print("Order Number: ${houseModel.status}");

      var result = await _crud.postRequest(
        "https://rctapp.com/api/design-and-sketches",
        {
          "description": houseModel.description,
          // "user_id": "",
          "design_id": houseModel.design_id,
          "orderNumber": houseModel.orderNumber,
          "status": "pending",
        },
      );

      print("Response from API: $result");

      if (result.containsKey("data")) {
        emit(DesignsSuccess(designs_Sketches));
      } else {
        emit(DesignsFaild("API response missing 'data' key."));
      }
    } catch (e) {
      emit(DesignsFaild("Error: $e"));
      print("Error during POST request: $e");
    }
  }

  Future<void> PostSketch(BuildContext context) async {
    HouseModel houseModel = Provider.of<HouseModel>(context, listen: false);
    emit(SketchLoading22());

    try {
      print("Description: ${houseModel.description}");
      print("Order Number: ${houseModel.orderNumber}");
      print("id: ${houseModel.design_id}");
      print("status: ${houseModel.status}");

      var result = await _crud.postRequest(
        "https://rctapp.com/api/sketch_and_designs",
        {
          "description": houseModel.description,
          // "user_id": "34",
          "sketch_id": houseModel.design_id,
          "orderNumber": houseModel.orderNumber,
          "status": "pending",
        },
      );

      print("Response from API: $result");

      if (result.containsKey("data")) {
        emit(SketchSuccess22(designs_Sketches));
      } else {
        emit(SketchFaild22("API response missing 'data' key."));
      }
    } catch (e) {
      emit(SketchFaild22("Error: $e"));
      print("Error during POST request: $e");
    }
  }

  // Static list to store names

  Future<void> Users() async {
    emit(UserLoading());
    final token = await _getAuthToken();

    try {
      final response = await _dio.get(
        "https://rctapp.com/api/user",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        var responseData = response.data;

        if (responseData != null) {
          if (responseData['id'] != null && responseData['name'] != null) {
            final Modelget user = Modelget.fromJson(responseData);

            String myImage = "$linkServerName/${responseData["image"]}";
            String myName = "${responseData["name"]}";

            // Add image and name to the static lists
            imageList.add(myImage);
            nameList.add(myName);

            emit(UserSucess([user]));

            // Persisting the image and name in SharedPreferences
            AppPreferences.saveData(key: 'myimage', value: myImage);
            AppPreferences.saveData(key: 'myname', value: myName);
          } else {
            emit(UserFaild('User data is incomplete.'));
          }
        } else {
          emit(UserFaild('No user data available.'));
        }
      } else {
        emit(UserFaild(
            'Failed to load data. Status code: ${response.statusCode}'));
      }
    } on DioError catch (e) {
      emit(UserFaild(
          'Dio error! STATUS: ${e.response?.statusCode}, DATA: ${e.response?.data}'));
    } catch (e) {
      emit(UserFaild('Unexpected error: $e'));
    }
  }

  static FinalOrdersCubit get(BuildContext context) => BlocProvider.of(context);
}

Future<String?> _getAuthToken() async {
  return AppPreferences.getData(key: 'loginToken');
}

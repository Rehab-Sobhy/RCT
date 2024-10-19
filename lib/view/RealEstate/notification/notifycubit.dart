import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/shared_pref.dart';
import 'package:rct/view-model/services/crud.dart';
import 'package:rct/view/RealEstate/notification/notify_model.dart';
import 'package:rct/view/RealEstate/notification/states.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

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
  List<NotificationModel> allDataList = [];

  Future<String?> _getAuthToken() async {
    return AppPreferences.getData(key: 'loginToken');
  }

  Future<void> fetchData(String url) async {
    emit(NotificationLoading());
    final token = await _getAuthToken();
    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        if (response.headers['content-type'] != null &&
            response.headers['content-type']!.contains('text/html')) {
          emit(NotificationError(
              'Response data is not in the expected JSON format.'));
          return;
        }

        if (response.data is Map) {
          var notifications = response.data['notifications'];
          if (notifications == null || notifications.isEmpty) {
            emit(NotificationError('No notifications available'));
            return;
          }

          allDataList = notifications
              .map<NotificationModel>(
                  (element) => NotificationModel.fromJson(element))
              .toList();
          emit(NotificationLoaded(allDataList));
        } else {
          emit(NotificationError(
              'Response data is not in the expected JSON format.'));
        }
      } else {
        emit(NotificationError(
            'Failed to load data. Status code: ${response.statusCode}'));
      }
    } on DioError catch (e) {
      emit(NotificationError(
          'Dio error! STATUS: ${e.response?.statusCode}, DATA: ${e.response?.data}, HEADERS: ${e.response?.headers}'));
    } catch (e) {
      emit(NotificationError('Error: $e'));
    }
  }

  List<NotificationModel> postNotification = [];

  Future<void> postNotify({
    int? data_id,
    String? type,
    int? agreed_terms,
    File? file,
  }) async {
    final token = await _getAuthToken();
    Map<String, File?> images = {
      'file': file,
    };

    emit(NotificationLoading());
    try {
      final response = await _crud.postRequestWithFiles(
        "https://rctapp.com/api/accept-admin-offer",
        {
          "data_id": data_id,
          "agreed_terms": agreed_terms,
          "type": type,
        },
        images,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('API response: ${response.toString()}');

      if (response is Map<String, dynamic>) {
        if (response.containsKey("data")) {
          final data = response["data"];
          print('Data: $data');
          emit(NotificationLoaded(postNotification));
        } else {
          print('Response keys: ${response.keys}');
          emit(NotificationError(
              "Unexpected response format. Response keys: ${response.keys}"));
        }
      } else {
        emit(NotificationError(
            "Unexpected response type. Response: ${response.toString()}"));
      }
    } catch (e) {
      print('Error in postNotify: $e');
      emit(NotificationError("$e"));
    }
  }

  static NotificationCubit get(BuildContext context) =>
      BlocProvider.of(context);
}

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/shared_pref.dart';
import 'package:rct/view/partener_success/model.dart';
import 'package:rct/view/partener_success/partener_states.dart';

class ParetenerCubit extends Cubit<PartenerStates> {
  ParetenerCubit() : super(IntialPartenerStates());

  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  Dio get dio => _dio;
  List<PartenerModel> data = [];

  // Method to get the authentication token
  Future<String?> _getAuthToken() async {
    return AppPreferences.getData(key: 'loginToken');
  }

  // Fetch partner data from the server
  Future<void> fetchData() async {
    emit(PartenerLoading());
    final token = await _getAuthToken();

    try {
      final response = await _dio.get(
        "https://rctapp.com/api/clients",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        var clients = response.data['data'];

        if (clients == null || clients.isEmpty) {
          emit(PartenerFailed(message: 'No clients available'));
          return;
        }

        data = clients
            .map<PartenerModel>((element) => PartenerModel.fromJson(element))
            .toList();
        emit(PartenerSuccess(data: data));
      } else {
        emit(PartenerFailed(
            message:
                'Failed to load data. Status code: ${response.statusCode}'));
      }
    } on DioError catch (e) {
      _handleDioError(e);
    } catch (e) {
      emit(PartenerFailed(message: 'Error: $e'));
    }
  }

  // Handle Dio errors in a centralized method
  void _handleDioError(DioError e) {
    if (e.response != null) {
      if (e.response?.statusCode == 403) {
        emit(PartenerFailed(
            message: 'Unauthorized access. Please check your credentials.'));
      } else {
        emit(PartenerFailed(
            message:
                'Error! STATUS: ${e.response?.statusCode}, DATA: ${e.response?.data}'));
      }
    } else {
      emit(PartenerFailed(message: 'Error sending request: ${e.message}'));
    }
  }

  static ParetenerCubit get(context) => BlocProvider.of(context);
}

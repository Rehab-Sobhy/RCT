import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'dart:convert'; // Ensure this import is present
import 'package:http/http.dart' as http;
import 'package:rct/view/RealEstate/modelget.dart';
import 'package:rct/view/RealEstate/states.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataCubit extends Cubit<DataState> {
  DataCubit() : super(DataInitial()) {
    _loadAllDataFromSharedPreferences();
    _loadFavoritesFromSharedPreferences();
  }

  final Dio _dio = Dio(BaseOptions(
    headers: {
      'Content-Type': 'application/json',
    },
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
  ));

  Dio get dio => _dio;
  List<Modelget> allDataList = [];
  List<Modelget>? filterList;
  List<Modelget>? searchList;
  List<Modelget>? filterbycategoryList;
  List<Modelget> favoriteList = [];

  Future<void> fetchData(String url) async {
    emit(DataLoading());
    try {
      final response = await _dio.get(url);
      print('Response status: ${response.statusCode}');
      print('Full response: ${response.data}');

      if (response.statusCode == 200) {
        var houses = response.data['houses'];
        print(houses[0]);
        print(houses[0]['image1']);

        if (houses == null || houses.isEmpty) {
          print('Houses data is null or empty');
          emit(DataError('No houses available'));
          return;
        }

        allDataList = [];
        houses.forEach((element) {
          allDataList.add(Modelget.fromJson(element));
        });

        // Save data to SharedPreferences after fetching

        emit(DataSuccess(allDataList));
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        emit(DataError(
            'Failed to load data. Status code: ${response.statusCode}'));
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print(
            'Dio error! STATUS: ${e.response?.statusCode}, DATA: ${e.response?.data}, HEADERS: ${e.response?.headers}');
        emit(DataError(
            'Dio error! STATUS: ${e.response?.statusCode}, DATA: ${e.response?.data}, HEADERS: ${e.response?.headers}'));
      } else {
        print('Error sending request: ${e.message}');
        emit(DataError('Error sending request: ${e.message}'));
      }
    } catch (e) {
      print('Error: $e');
      emit(DataError('Error: $e'));
    }
    print(allDataList.length);
  }

  Future<void> FilteredData({
    required String city,
    required String district,
  }) async {
    emit(FilterloadingssState());

    filterList = allDataList.where((element) {
      bool cityyy = element.city_name != null &&
          element.city_name!.toLowerCase().contains(city.toLowerCase());
      bool districttt = element.district_name != null &&
          element.district_name!.toLowerCase().contains(district.toLowerCase());

      return cityyy && districttt;
    }).toList();

    emit(FilterSuccessState(filterList!));
    print("filter list");
  }

  void SearchHouse({required String input}) {
    searchList = allDataList.where((element) {
      bool cityyy = element.city_name != null &&
          element.city_name!.toLowerCase().contains(input.toLowerCase());
      bool districttt = element.district_name != null &&
          element.district_name!.toLowerCase().contains(input.toLowerCase());

      return cityyy || districttt;
    }).toList();
    emit(SearchSuccss());
    print("search list ");
  }

  Future<void> filterByCategory(String category) async {
    emit(DataLoading());
    try {
      filterbycategoryList = allDataList.where((item) {
        return item.house_type?.toLowerCase() == category.toLowerCase();
      }).toList();

      emit(FilterCategorySuccessState(filterbycategoryList!));
    } catch (error) {
      emit(DataError(error.toString()));
    }
  }

  Future<void> fetchNotifications() async {
    final url = Uri.parse('https://rctapp.com/api/testnotification');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List notifications = json.decode(response.body)['notifications'];
      print('Notifications: $notifications');
    } else {
      print('Failed to fetch notifications');
    }
  }

  Future<void> _loadFavoritesFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? favoriteItems = prefs.getStringList('favoriteItems');

    if (favoriteItems != null) {
      favoriteList = favoriteItems
          .map((item) => Modelget.fromJson(json.decode(item)))
          .toList();
    }

    emit(FavouriteSuccess(favoriteList));
  }

  // Toggle favorite status
  Future<void> toggleFavorite(Modelget house) async {
    if (favoriteList.any((favoriteHouse) => favoriteHouse.id == house.id)) {
      favoriteList.removeWhere((favoriteHouse) => favoriteHouse.id == house.id);
    } else {
      favoriteList.add(house);
    }

    await _saveFavoritesToSharedPreferences();
    emit(FavouriteSuccess(favoriteList));
  }

  Future<void> _loadAllDataFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? allDataItems = prefs.getStringList('allDataItems');

    if (allDataItems != null) {
      allDataList = allDataItems
          .map((item) => Modelget.fromJson(json.decode(item)))
          .toList();

      emit(DataSuccess(allDataList));
    }
  }

  // Save favorite list to SharedPreferences
  Future<void> _saveFavoritesToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteItems =
        favoriteList.map((house) => json.encode(house.toJson())).toList();
    await prefs.setStringList('favoriteItems', favoriteItems);
  }

  static DataCubit get(context) => BlocProvider.of(context);
}

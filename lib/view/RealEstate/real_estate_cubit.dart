import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rct/view/RealEstate/modelget.dart';
import 'package:rct/view/RealEstate/states.dart';
import 'package:shared_preferences/shared_preferences.dart';

// State Classes
class SearchSuccess extends DataState {
  final List<Modelget> searchResults;

  SearchSuccess(this.searchResults);
}

class FilterLoadingsState extends DataState {}

// DataCubit Class
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

  List<Modelget> allDataList = [];
  List<Modelget>? filterList;
  List<Modelget>? searchList;
  List<Modelget>? filterbycategoryList;
  List<Modelget> favoriteList = [];

  Future<void> fetchData(String url) async {
    emit(DataLoading());
    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        var houses = response.data['houses'];
        if (houses == null || houses.isEmpty) {
          emit(DataError('No houses available'));
          return;
        }

        allDataList = houses.map<Modelget>((element) {
          return Modelget.fromJson(element);
        }).toList();

        emit(DataSuccess(allDataList)); // Emit success with the data
      } else {
        emit(DataError(
            'Failed to load data. Status code: ${response.statusCode}'));
      }
    } catch (e) {
      emit(DataError('Error: $e'));
    }
  }

  void filterData({
    required String city,
    required String district,
    required int maxPrice,
  }) {
    final filtered = allDataList.where((item) {
      // Convert the `price` field to a double for comparison
      final itemPrice = double.tryParse(item.price ?? "0") ?? 0;

      return item.city_name == city &&
          item.district_name == district &&
          itemPrice <= maxPrice;
    }).toList();

    emit(FilterSuccessState(filtered));
  }

  void SearchHouse({required String input}) {
    searchList = allDataList.where((element) {
      bool cityMatches = element.city_name != null &&
          element.city_name!.toLowerCase().contains(input.toLowerCase());
      bool districtMatches = element.district_name != null &&
          element.district_name!.toLowerCase().contains(input.toLowerCase());

      return cityMatches || districtMatches;
    }).toList();

    if (searchList!.isNotEmpty) {
      emit(SearchSuccess(searchList!));
    } else {
      emit(DataError('No results found for your search.'));
    }
  }

  Future<void> filterByCategory(String category) async {
    emit(DataLoading());
    try {
      filterbycategoryList = allDataList.where((item) {
        return item.house_type?.toLowerCase() == category.toLowerCase();
      }).toList();

      if (filterbycategoryList!.isEmpty) {
        emit(DataError("No houses available in this category."));
      } else {
        emit(FilterSuccessState(filterbycategoryList!));
      }
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
  }

  Future<void> toggleFavorite(Modelget house) async {
    if (favoriteList.any((favoriteHouse) => favoriteHouse.id == house.id)) {
      favoriteList.removeWhere((favoriteHouse) => favoriteHouse.id == house.id);
    } else {
      favoriteList.add(house);
    }

    await _saveFavoritesToSharedPreferences();
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

  Future<void> _saveFavoritesToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteItems =
        favoriteList.map((house) => json.encode(house.toJson())).toList();
    await prefs.setStringList('favoriteItems', favoriteItems);
  }

  static DataCubit get(context) => BlocProvider.of(context);
}

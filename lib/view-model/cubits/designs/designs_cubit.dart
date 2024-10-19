import 'dart:convert'; // Import for JSON encoding/decoding
import 'package:bloc/bloc.dart'; // Import for BLoC state management
import 'package:dio/dio.dart'; // Import for HTTP requests
import 'package:flutter/material.dart'; // Import for Flutter widgets
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/shared_pref.dart'; // Import for custom shared preferences handling
import 'package:rct/view-model/cubits/designs/designs_state.dart'; // Import for DesignsCubit states
import 'package:shared_preferences/shared_preferences.dart'; // Import for SharedPreferences
import 'package:rct/constants/linkapi.dart'; // Import for API constants

class DesignsCubit extends Cubit<DesignsState> {
  final Dio _dio = Dio(); // Initialize Dio for HTTP requests
  List<Map<String, dynamic>> _favoriteList =
      []; // List to keep track of favorite designs

  DesignsCubit() : super(DesignsInitial()) {
    _loadFavorites(); // Load favorites when cubit is initialized
  }

  List<Map<String, dynamic>> get favoriteList => _favoriteList;

  Future<String?> _getAuthToken() async {
    return AppPreferences.getData(key: 'loginToken');
  }

  Future<void> loadDesigns(BuildContext context) async {
    emit(DesignsLoading());
    final token = await _getAuthToken();
    try {
      // Include headers in the request

      // Make GET request with Dio
      final response = await _dio.get(
        linkDesign,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ), // Pass headers in request options
      );

      if (response.data.containsKey("data")) {
        emit(DesignsSuccess(designs: response.data["data"]));
      } else {
        emit(DesignsFailure(errMessage: response.data.entries.toString()));
      }
    } catch (e) {
      emit(DesignsFailure(errMessage: "$e"));
    }
  }

  void toggleFavorite(Map<String, dynamic> design) async {
    // Check if the design is already in the favorites list by comparing encoded JSON strings
    if (_favoriteList.any((item) => jsonEncode(item) == jsonEncode(design))) {
      _favoriteList
          .removeWhere((item) => jsonEncode(item) == jsonEncode(design));
    } else {
      _favoriteList.add(design);
    }

    // Save updated favorites list to SharedPreferences
    await _saveFavorites();

    // Re-emit the current state to refresh the UI
    if (state is DesignsSuccess) {
      emit(DesignsSuccess(designs: (state as DesignsSuccess).designs));
    }
  }

  bool isFavorite(Map<String, dynamic> design) {
    // Check if the design exists in the favorite list by comparing encoded JSON strings
    return _favoriteList.any((item) => jsonEncode(item) == jsonEncode(design));
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = prefs.getStringList('designsFavorites') ?? [];

      // Decode the JSON strings back to Map<String, dynamic>
      _favoriteList =
          favorites.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();

      if (state is DesignsSuccess) {
        // Re-emit DesignsSuccess state to refresh the UI with loaded favorites
        emit(DesignsSuccess(designs: (state as DesignsSuccess).designs));
      } else {
        emit(DesignsFailure(errMessage: "Failed to load favorites."));
      }
    } catch (e) {
      emit(DesignsFailure(errMessage: "Error loading favorites: $e"));
    }
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Encode each Map<String, dynamic> in the favorites list to a JSON string
      List<String> encodedFavorites =
          _favoriteList.map((e) => jsonEncode(e)).toList();

      // Save the list of JSON strings to SharedPreferences
      await prefs.setStringList('designsFavorites', encodedFavorites);
    } catch (e) {
      // Handle any errors that occur during saving
      emit(DesignsFailure(errMessage: "Error saving favorites: $e"));
    }
  }

  static DesignsCubit get(context) => BlocProvider.of(context);
}

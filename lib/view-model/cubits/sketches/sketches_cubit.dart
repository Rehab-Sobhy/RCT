import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/view-model/cubits/sketches/sketches_state.dart';
import 'package:rct/view-model/services/crud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SketchesCubit extends Cubit<SketchesState> {
  final Crud _crud = Crud();
  List<Map<String, dynamic>> _favoriteList =
      []; // List to keep track of favorite sketches

  SketchesCubit() : super(SketchesInitial()) {
    _loadFavorites(); // Load favorites when cubit is initialized
  }

  Future<void> loadSketches(BuildContext context) async {
    emit(SketchesLoading());
    try {
      final response = await _crud.getRequest(linkSketches);
      if (response.containsKey("data")) {
        if (kDebugMode) {
          print(response["data"]);
        }
        emit(SketchesSuccess(sketches: response["data"]));
      } else {
        emit(SketchesFailure(errMessage: response.entries.toString()));
        if (kDebugMode) {
          print(response.entries.toString());
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(SketchesFailure(errMessage: "$e"));
    }
  }

  // Method to toggle favorite status
  void toggleFavorite(Map<String, dynamic> sketch) async {
    if (_favoriteList.any((item) => mapEquals(item, sketch))) {
      _favoriteList.removeWhere((item) => mapEquals(item, sketch));
    } else {
      _favoriteList.add(sketch);
    }
    await _saveFavorites(); // Save updated favorites
    if (state is SketchesSuccess) {
      emit(SketchesSuccess(
          sketches: (state as SketchesSuccess)
              .sketches)); // Re-emit the state to update UI
    }
  }

  // Method to check if a sketch is a favorite
  bool isFavorite(Map<String, dynamic> sketch) {
    return _favoriteList.any((item) => mapEquals(item, sketch));
  }

  // Getter for the favorite list
  List<Map<String, dynamic>> get favoriteList => _favoriteList;

  // Load favorites from local storage
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('sketchesFavorites') ?? [];
    _favoriteList = favorites
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .toList(); // Decode the stored JSON strings into maps
    if (state is SketchesSuccess) {
      emit(SketchesSuccess(
          sketches: (state as SketchesSuccess)
              .sketches)); // Re-emit the state to update UI
    } else {
      emit(SketchesInitial());
    }
  }

  // Save favorites to local storage
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> encodedFavorites =
        _favoriteList.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList('sketchesFavorites', encodedFavorites);
  }

  static SketchesCubit get(context) => BlocProvider.of(context);
}

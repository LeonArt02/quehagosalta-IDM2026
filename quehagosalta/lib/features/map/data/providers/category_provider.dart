import 'dart:io';

import 'package:flutter/material.dart';

import 'package:quehagosalta/features/map/data/models/category_model.dart';
import 'package:quehagosalta/features/map/data/services/category_services.dart';

class CategoryProvider extends ChangeNotifier {
  final List<CategoryModel> _categories = [];
  final CategoryServices _categoryServices;
  bool isLoading = false;

  List<CategoryModel> get categories => _categories;

  CategoryProvider(this._categoryServices);

  Future<void> loadCategories() async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await _categoryServices.getCategories();

      if (response['success'] == true) {
        _categories.clear();
        final List<dynamic> dataList = response['data'];

        for (var item in dataList) {
          _categories.add(CategoryModel.fromJson(item));
        }
      } else {
        debugPrint('devuelto por el servicio: ${response['message']}');
      }
    } catch (e) {
      debugPrint('Error inesperado en CategoryProvider: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

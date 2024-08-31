import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_ecommerce/models/category_model.dart';

class CategoryService {
  static Future getCategories() async {
    final Dio dio = Dio();
    try {
      const url = "https://api.escuelajs.co/api/v1/categories";
      log("Url $url");
      final response = await dio.get(url);
      final List<CategoryModel> resData = response.data.map<CategoryModel>((e) {
        return CategoryModel.fromJson(e);
      }).toList();
      return resData;
    } on DioException catch (e) {
      log("Error ${e.response}");
      return e.response;
    }
  }
}

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_ecommerce/models/product_model.dart';

class ProductService {
  static Future getProducts({offset = 0, limit = 4}) async {
    final Dio dio = Dio();
    try {
      final url =
          "https://api.escuelajs.co/api/v1/products?offset=$offset&limit=$limit";
      log("Url $url");
      final response = await dio.get(url);

      final List<ProductModel> productModel = response.data
          .map<ProductModel>((e) => ProductModel.fromJson(e))
          .toList();

      return productModel;
    } on DioException catch (e) {
      log("Error ${e.response}");
      return e.response;
    }
  }

  static Future getProductInfo(id) async {
    final Dio dio = Dio();
    try {
      final url = "https://api.escuelajs.co/api/v1/products/$id";
      log("Url $url");
      final response = await dio.get(url);

      log("Response ${response.data}");

      ProductModel resData = ProductModel.fromJson(response.data);

      return resData;
    } on DioException catch (e) {
      log("Error ${e.response}");
      return e.response;
    }
  }
}

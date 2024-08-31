import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:hive_flutter/adapters.dart';

class Auth {
  static Future register(
      {required String email,
      required String password,
      required String name}) async {
    final Dio dio = Dio();
    try {
      const url = "https://api.escuelajs.co/api/v1/users/";
      final body = {
        "email": email,
        "password": password,
        "name": name,
        "avatar": "avatar.png"
      };

      final response = await dio.post(url, data: body);
      return response;
    } on DioException catch (e) {
      log("Error ${e.response}");
      return e.response;
    }
  }

  static Future checkEmail({required String email}) async {
    final Dio dio = Dio();
    try {
      const url = "https://api.escuelajs.co/api/v1/users/is-available";
      log("Url $url");
      log("Email $email");
      final response = await dio.post(url, data: {"email": email});
      return response;
    } on DioException catch (e) {
      log("Error ${e.response}");
      return e.response;
    }
  }

  static Future login({required String email, required String password}) async {
    final Dio dio = Dio();
    try {
      const url = "https://api.escuelajs.co/api/v1/auth/login";
      final body = {"email": email, "password": password};
      final response = await dio.post(url, data: body);
      return response;
    } on DioException catch (e) {
      log("Error ${e.response}");
      return e.response;
    }
  }

  static Future getProfile() async {
    final Dio dio = Dio();
    final box = await Hive.openBox("token");
    final token = box.get("token");
    try {
      const url = "https://api.escuelajs.co/api/v1/auth/profile";
      final response = await dio.get(url,
          options: Options(headers: {"Authorization": "Bearer $token"}));
      return response;
    } on DioException catch (e) {
      log("Error ${e.response}");
      return e.response;
    }
  }
}

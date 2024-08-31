import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class Toast {
  static void show(
      {required String title,
      required String description,
      required ToastificationType type}) {
    toastification.show(
      type: type,
      style: ToastificationStyle.fillColored,
      title: Text(title),
      description: Text(description),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 3),
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: highModeShadow,
      dragToClose: true,
      pauseOnHover: false,
      showProgressBar: false,
      padding: const EdgeInsets.all(10.0),
    );
  }
}

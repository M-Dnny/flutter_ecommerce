import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) {
  if (Hive.box("theme").get("themeMode") != null) {
    final themeMode = Hive.box('theme').get('themeMode') == "dark"
        ? ThemeMode.dark
        : ThemeMode.light;

    return themeMode;
  }

  return ThemeMode.system;
});

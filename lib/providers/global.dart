import 'package:flutter_riverpod/flutter_riverpod.dart';

final appVersionProvider = StateProvider<String>((ref) {
  return "";
});

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

final userNameProvider = StateProvider<String>((ref) => "");

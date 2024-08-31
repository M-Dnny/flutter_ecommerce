import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/providers/theme_prov/theme.dart';
import 'package:flutter_ecommerce/utils/routes/routes.dart';
import 'package:flutter_ecommerce/utils/theme/theme.dart';
import 'package:flutter_ecommerce/utils/theme/util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox("theme");
  await Hive.openBox("wishlist");
  await Hive.openBox("cart");

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextTheme textTheme = createTextTheme(context, "Oxygen", "Oxygen");
    MaterialTheme theme = MaterialTheme(textTheme);
    return ToastificationWrapper(
      child: MaterialApp.router(
        routerConfig: router,
        theme: theme.light().copyWith(
                pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: ZoomPageTransitionsBuilder(),
                TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
              },
            )),
        darkTheme: theme.dark().copyWith(
                pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: ZoomPageTransitionsBuilder(),
                TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
              },
            )),
        themeMode: ref.watch(themeModeProvider),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/providers/global.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    getAppVersion();
  }

  getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    ref.read(appVersionProvider.notifier).state = packageInfo.version;

    Future.delayed(const Duration(seconds: 2), () {
      loginCheck();
    });
  }

  loginCheck() async {
    final box = await Hive.openBox("token");
    final token = box.get("token");
    if (token != null) {
      bottomNav();
    } else {
      final firstTimeBox = await Hive.openBox("firstTime");
      final firstTime = firstTimeBox.get("firstTime");
      if (firstTime == null) {
        onBoard();
      } else {
        bottomNav();
      }
    }
  }

  onBoard() {
    context.go("/onBoarding");
  }

  bottomNav() {
    context.go("/bottom_nav");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Center(
            child: Text(
              "Shopster",
              style: GoogleFonts.tangerine(
                textStyle: Theme.of(context).textTheme.displayLarge,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              "The ultimate shopping experience",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.white),
            ),
          ),
          const Spacer(),
          Text(
            "Version ${ref.watch(appVersionProvider)}",
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

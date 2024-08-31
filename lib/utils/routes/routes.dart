import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/screens/auth/login.dart';
import 'package:flutter_ecommerce/screens/auth/register.dart';
import 'package:flutter_ecommerce/screens/auth/verify_otp.dart';
import 'package:flutter_ecommerce/screens/detail/detail_screen.dart';
import 'package:flutter_ecommerce/screens/onBoard/on_boarding.dart';
import 'package:flutter_ecommerce/screens/seeAll/see_all.dart';
import 'package:flutter_ecommerce/screens/splash/splash.dart';
import 'package:flutter_ecommerce/utils/routes/bottom_nav.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: "/",
      name: "splash",
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const SplashScreen(),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    GoRoute(
      path: "/onBoarding",
      name: "onBoarding",
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const OnBoarding(),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    GoRoute(
      path: "/register",
      name: "register",
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const RegisterScreen(),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    GoRoute(
      path: "/verify-otp",
      name: "verify-otp",
      pageBuilder: (context, state) => CustomTransitionPage(
        child: VerifyOtp(data: state.extra as Map<String, dynamic>),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    GoRoute(
      path: "/login",
      name: "login",
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const LoginScreen(),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    GoRoute(
      path: "/bottom_nav",
      name: "bottom_nav",
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const BottomNav(),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    GoRoute(
        path: "/detail",
        name: "detail",
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const DetailScreen(),
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        }),
    GoRoute(
        path: "/see_all",
        name: "see_all",
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return CustomTransitionPage(
            child: SeeAllScreen(title: data["title"]),
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        }),
  ],
);

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/services/auth_service.dart';
import 'package:flutter_ecommerce/utils/widgets/custom_text_input.dart';
import 'package:flutter_ecommerce/utils/widgets/loading_dialog.dart';
import 'package:flutter_ecommerce/utils/widgets/toasts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:toastification/toastification.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final mobileOrMailController = TextEditingController();
  final passwordController = TextEditingController();
  bool passwordVisible = true;
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    mobileOrMailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  onSubmit() {
    if (formKey.currentState!.validate()) {
      if (formKey.currentState!.validate()) {
        showLoadingDialog(context);
        try {
          Auth.login(
            email: mobileOrMailController.text,
            password: passwordController.text,
          ).then((value) async {
            final tokenBox = await Hive.openBox("token");
            final refTokenBox = await Hive.openBox("refresh_token");

            if (value.data != null && value.statusCode == 201) {
              if (mounted) {
                hideLoadingDialog(context);
                Toast.show(
                    type: ToastificationType.success,
                    title: "Success",
                    description: "Login successfully");
                tokenBox.put("token", value.data['access_token']);
                refTokenBox.put("refresh_token", value.data['refresh_token']);

                context.go("/bottom_nav");
              }
            } else {
              if (mounted) {
                hideLoadingDialog(context);
                Toast.show(
                    type: ToastificationType.error,
                    title: "Error",
                    description: "Email or password is incorrect");
              }
            }
          }).catchError((e) {
            if (mounted) {
              hideLoadingDialog(context);
              Toast.show(
                  type: ToastificationType.error,
                  title: "Error",
                  description: "Something went wrong");
            }
          });
        } catch (e) {
          log("Error $e");
          hideLoadingDialog(context);
          Toast.show(
              type: ToastificationType.error,
              title: "Error",
              description: "Something went wrong");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formKey,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Login Account",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Please login with registered account",
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: Theme.of(context).hintColor),
                  ),
                  const SizedBox(height: 25),
                  MyTextInput(
                    controller: mobileOrMailController,
                    validator: (value) {
                      final emailRegex = RegExp(
                          r'^[a-zA-Z0-9+._%\-]{1,256}@([a-zA-Z0-9\-]{1,256}\.){1,5}[a-zA-Z]{2,256}$');

                      if (value == null || value.trim().isEmpty) {
                        return '*Please enter email';
                      } else if (!emailRegex.hasMatch(value)) {
                        return '*Please enter valid email';
                      }

                      return null;
                    },
                    hintText: "Enter your email",
                    labelText: "Email",
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 25),
                  PasswordTextInput(
                    controller: passwordController,
                    validator: (value) {
                      final regex = RegExp(
                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');

                      if (value == null || value.trim().isEmpty) {
                        return '*Please enter password';
                      }
                      if (!regex.hasMatch(value)) {
                        return "Password must contain at least${"\n"}*One uppercase letter${"\n"}*One lowercase letter${"\n"}*One number";
                      }
                      return null;
                    },
                    hintText: "Enter password",
                    labelText: "Password",
                    icon: Icons.lock_outline_rounded,
                    obscureText: passwordVisible,
                    onTap: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        child: const Text("Forgot Password?")),
                  ),
                  const SizedBox(height: 40),
                  FilledButton(
                    onPressed: () => onSubmit(),
                    style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 55),
                        textStyle:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                )),
                    child: const Text("Login"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

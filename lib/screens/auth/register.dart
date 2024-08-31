import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/utils/widgets/custom_text_input.dart';
import 'package:flutter_ecommerce/utils/widgets/loading_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool passwordVisible = true;
  bool confirmPasswordVisible = true;
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    mailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  onSubmit() async {
    if (formKey.currentState!.validate()) {
      showLoadingDialog(context);
      final data = {
        "name": nameController.text,
        "email": mailController.text,
        "password": passwordController.text,
      };

      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        hideLoadingDialog(context);
        context.push("/verify-otp", extra: data);
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
                    "Create Account",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Register to get started",
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: Theme.of(context).hintColor),
                  ),
                  const SizedBox(height: 25),
                  MyTextInput(
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '*Please enter name';
                      }
                      if (value.length < 3) {
                        return '*Name must be at least 3 characters';
                      }
                      return null;
                    },
                    hintText: "Enter name",
                    labelText: "Name",
                    icon: Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: 25),
                  MyTextInput(
                    controller: mailController,
                    validator: (value) {
                      final emailRegex = RegExp(
                          r'^[a-zA-Z0-9+._%\-]{1,256}@([a-zA-Z0-9\-]{1,256}\.){1,5}[a-zA-Z]{2,256}$');

                      if (value == null || value.trim().isEmpty) {
                        return '*Please enter email';
                      } else if (!emailRegex.hasMatch(value)) {
                        return '*Please enter valid a email';
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
                  const SizedBox(height: 25),
                  PasswordTextInput(
                    controller: confirmPasswordController,
                    validator: (value) {
                      final regex = RegExp(
                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');

                      if (value == null || value.trim().isEmpty) {
                        return '*Please confirm your password';
                      }
                      if (!regex.hasMatch(value)) {
                        return "Password must contain at least${"\n"}*One uppercase letter${"\n"}*One lowercase letter${"\n"}*One number";
                      }

                      if (value != passwordController.text) {
                        return 'Password does not match';
                      }
                      return null;
                    },
                    hintText: "Confirm your password",
                    labelText: "Confirm Password",
                    icon: Icons.lock_outline_rounded,
                    obscureText: confirmPasswordVisible,
                    onTap: () {
                      setState(() {
                        confirmPasswordVisible = !confirmPasswordVisible;
                      });
                    },
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
                    child: const Text("Create Account"),
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

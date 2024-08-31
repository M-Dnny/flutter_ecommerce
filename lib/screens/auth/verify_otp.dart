import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/services/auth_service.dart';
import 'package:flutter_ecommerce/utils/widgets/loading_dialog.dart';
import 'package:flutter_ecommerce/utils/widgets/toasts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:toastification/toastification.dart';

class VerifyOtp extends ConsumerStatefulWidget {
  const VerifyOtp({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  ConsumerState createState() => _VerifyOtpState();
}

class _VerifyOtpState extends ConsumerState<VerifyOtp> {
  final otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    otpController.dispose();
  }

  onSubmit() {
    if (formKey.currentState!.validate()) {
      showLoadingDialog(context);
      try {
        Auth.register(
                email: widget.data["email"],
                password: widget.data["password"],
                name: widget.data["name"])
            .then(
          (value) {
            log("Response $value");
            if (value.data != null && value.statusCode == 201) {
              if (mounted) {
                hideLoadingDialog(context);
                Toast.show(
                    type: ToastificationType.success,
                    title: "Success",
                    description: "Account created successfully");

                context.go("/login");
              }
            } else {
              if (mounted) {
                hideLoadingDialog(context);
                Toast.show(
                    type: ToastificationType.error,
                    title: "Error",
                    description: "Something went wrong");
              }
            }
          },
        ).catchError((e) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verification"),
        titleTextStyle: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontWeight: FontWeight.bold),
        centerTitle: true,
        elevation: 0,
        forceMaterialTransparency: true,
        shape: Border(
          bottom: BorderSide(
              color: Theme.of(context).highlightColor.withOpacity(0.8),
              width: 0.5),
        ),
      ),
      body: SafeArea(
          child: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18.0),
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color:
                          Theme.of(context).primaryColorLight.withOpacity(0.7),
                      shape: BoxShape.circle),
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle),
                    child: const Icon(Icons.mail_lock_rounded,
                        size: 30, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Verification Code",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  "Enter the verification code we just sent you on your email",
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme.of(context).hintColor),
                ),
                const SizedBox(height: 5),
                Text(widget.data['email'],
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 40),
                Pinput(
                  controller: otpController,
                  length: 4,
                  focusedPinTheme: PinTheme(
                    height: 55,
                    width: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.6),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  defaultPinTheme: PinTheme(
                    height: 55,
                    width: 50,
                    textStyle: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.3),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  errorTextStyle: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Theme.of(context).colorScheme.error),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter OTP';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 50),
                FilledButton(
                  onPressed: () => onSubmit(),
                  style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 55),
                      textStyle: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold)),
                  child: const Text("Submit"),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {},
                  child: Text.rich(
                    TextSpan(
                      text: "Didn't receive code? ",
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(color: Theme.of(context).hintColor),
                      children: [
                        TextSpan(
                          text: "Resend",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}

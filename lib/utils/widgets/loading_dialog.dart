import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

//to show our dialog
Future<void> showLoadingDialog(
  BuildContext context,
) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: LoadingAnimationWidget.threeArchedCircle(
              color: Colors.blue, size: 30),
        ),
      );
    },
  );
}

// to hide our current dialog
void hideLoadingDialog(BuildContext context) {
  Navigator.of(context).pop();
}

import 'package:flutter/material.dart';

class ProductHeader extends StatelessWidget {
  const ProductHeader(
      {super.key,
      required this.title,
      required this.onPressed,
      required this.buttonText});

  final String title;
  final String buttonText;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            textStyle: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          child: Text(buttonText),
        )
      ],
    );
  }
}

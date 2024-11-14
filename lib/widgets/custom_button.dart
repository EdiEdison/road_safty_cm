import 'package:flutter/material.dart';

class buttonBuilder extends StatelessWidget {
  final String? text;
  final Color? background;
  final Color? textColor;
  final VoidCallback? onPressed;
  const buttonBuilder(
      {super.key, this.text, this.background, this.textColor, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Ink(
        height: 60,
        decoration: BoxDecoration(
            color: background,
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                text!,
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: textColor),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../core.dart';

class PrimaryButton extends StatelessWidget {
  final Function? onPressed;
  final String text;
  final double width;
  final Color? textColor;
  final Color? backroundColor;

  const PrimaryButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.width = 180,
    this.textColor,
    this.backroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => onPressed!(),
        style: ElevatedButton.styleFrom(
            primary: backroundColor ?? AppColors.kPrimaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40))),
        child: Container(
          width: width,
          height: 50,
          padding: EdgeInsets.all(3),
          alignment: Alignment.center,
          child: Text(
            text,
            style:
                AppTextStyles.roundedButtonStyle().copyWith(color: textColor),
          ),
        ));
  }
}

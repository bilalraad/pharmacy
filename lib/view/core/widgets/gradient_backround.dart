import 'package:flutter/material.dart';

import '../core.dart';

class GradientBackround extends StatelessWidget {
  final Widget child;
  const GradientBackround({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.kPrimaryLightColor,
            AppColors.kPrimaryLightColor,
            // AppColors.kPrimaryLightColor,
            // AppColors.kPrimaryLightColor,
          ],
        )),
        alignment: Alignment.bottomCenter,
        child: child,
      ),
    );
  }
}

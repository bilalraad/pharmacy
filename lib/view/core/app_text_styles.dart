import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './app_colors.dart';

class AppTextStyles {
  static TextStyle inputStyle({
    double size = 16,
    FontWeight fontWeight = FontWeight.w400,
  }) =>
      GoogleFonts.roboto(
        color: AppColors.kPrimaryColor,
        fontSize: size,
        fontWeight: fontWeight,
      );
  static TextStyle subHeaderStyle({
    double size = 22,
    FontWeight fontWeight = FontWeight.w400,
  }) =>
      GoogleFonts.roboto(
        color: AppColors.black,
        fontSize: size,
        fontWeight: fontWeight,
      );
  static TextStyle headerStyle({
    double size = 25,
    FontWeight fontWeight = FontWeight.w700,
  }) =>
      GoogleFonts.roboto(
        color: AppColors.black,
        fontSize: size,
        fontWeight: fontWeight,
      );
  static TextStyle textButtonStyle({
    double size = 16,
    FontWeight fontWeight = FontWeight.w600,
  }) =>
      GoogleFonts.roboto(
        color: AppColors.kPrimaryColor,
        fontSize: size,
        fontWeight: fontWeight,
      );
  static TextStyle roundedButtonStyle({
    double size = 16,
    FontWeight fontWeight = FontWeight.w400,
  }) =>
      GoogleFonts.roboto(
        color: AppColors.white,
        fontSize: size,
        fontWeight: fontWeight,
      );
  static TextStyle body(
          {double size = 16,
          FontWeight fontWeight = FontWeight.w400,
          Color textColor = AppColors.black}) =>
      GoogleFonts.roboto(
        color: textColor,
        fontSize: size,
        fontWeight: fontWeight,
      );
}

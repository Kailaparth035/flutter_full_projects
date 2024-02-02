import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../util/colors.dart';

ThemeData basicTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    dialogBackgroundColor: Colors.white,
    datePickerTheme: DatePickerThemeData(
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.sp))),
    ),
    dialogTheme: const DialogTheme(surfaceTintColor: Colors.white),
    canvasColor: Colors.white,
    primaryColor: AppColors.primaryColor,
    secondaryHeaderColor: AppColors.secondaryColor,
    disabledColor: AppColors.secondaryColor,
    /*errorColor: AppColors.errorColor,*/
    brightness: Brightness.light,
    hintColor: AppColors.hintColor,
    cardColor: Colors.white,
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primaryColor)),
    colorScheme: const ColorScheme.light(
            primary: AppColors.primaryColor,
            secondary: AppColors.primaryColor,
            background: AppColors.white)
        .copyWith(background: AppColors.white),
  );
}

ThemeData darkTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    dialogBackgroundColor: Colors.white,
    canvasColor: Colors.white,
    primaryColor: AppColors.primaryColor,
    secondaryHeaderColor: AppColors.secondaryColor,
    disabledColor: AppColors.secondaryColor,
    /*errorColor: AppColors.errorColor,*/
    brightness: Brightness.light,
    hintColor: AppColors.hintColor,
    cardColor: Colors.white,
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primaryColor)),
    colorScheme: const ColorScheme.light(
            primary: AppColors.primaryColor,
            secondary: AppColors.primaryColor,
            background: AppColors.white)
        .copyWith(background: AppColors.white),
  );
}

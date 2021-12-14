import 'package:flutter/material.dart';

Color primaryColor = Color(0xFF4a148c);
Color lightGrey = Colors.grey.withAlpha(25);
ThemeData appThemeLight =
    ThemeData.light().copyWith(primaryColor: primaryColor);
ThemeData appThemeDark = ThemeData.dark().copyWith(
  primaryColor: Colors.white,
  toggleableActiveColor: primaryColor,
);

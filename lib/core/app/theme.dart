import 'package:flutter/material.dart';

var nPrimaryColor = Color(0xFF7b1fa2);

ThemeData appThemeLight =
    ThemeData.light().copyWith(primaryColor: nPrimaryColor);
ThemeData appThemeDark = ThemeData.dark().copyWith(
    textTheme: ThemeData.dark().primaryTextTheme.apply(
          fontFamily: 'Source Sans Pro',
        ),
    primaryColor: Colors.white,
    toggleableActiveColor: nPrimaryColor,
    accentColor: nPrimaryColor,
    buttonColor: nPrimaryColor,
    textSelectionColor: nPrimaryColor,
    textSelectionHandleColor: nPrimaryColor);

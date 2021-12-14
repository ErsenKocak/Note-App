import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:note_app/core/app/theme.dart';
import 'package:note_app/core/storage/shared_manager.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  var selectedTheme = appThemeDark.obs;
  var themeMode = ThemeMode.light;
  updateThemeFromSharedPref() async {
    String? themeText = await getThemeFromSharedPref();
    if (themeText == 'light') {
      selectedTheme.value = appThemeLight;
      themeMode = ThemeMode.light;
    } else {
      selectedTheme.value = appThemeDark;
      themeMode = ThemeMode.dark;
    }
  }

  changeThemeMode() async {
    String? themeText = await getThemeFromSharedPref();
    if (themeText == 'light') {
      Get.changeTheme(appThemeDark);
      setThemeinSharedPref('dark');
      selectedTheme.value = appThemeDark;
    } else {
      Get.changeTheme(appThemeLight);
      setThemeinSharedPref('light');
      selectedTheme.value = appThemeLight;
    }
  }

  Future<ThemeMode> getThemeMode() async {
    String? themeText = await getThemeFromSharedPref();
    if (themeText == 'light') {
      selectedTheme.value = appThemeLight;
      return ThemeMode.light;
    } else {
      selectedTheme.value = appThemeDark;
      return ThemeMode.dark;
    }
  }
}

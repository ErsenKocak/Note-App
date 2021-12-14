import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getThemeFromSharedPref() async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  return sharedPref.getString('theme');
}

setThemeinSharedPref(String val) async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  sharedPref.setString('theme', val);
}

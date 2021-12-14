import 'package:get_it/get_it.dart';
import 'package:note_app/controllers/theme_controller.dart';

import 'package:note_app/service/database_service.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerFactory(() => ThemeController());
  getIt.registerFactory(() => DatabaseService());
}

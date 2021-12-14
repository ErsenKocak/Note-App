import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';
import 'package:note_app/core/widgets/photo_view/photo_view_widget.dart';
import 'package:note_app/ui/screens/edit/edit_view.dart';
import 'package:note_app/ui/screens/note/note_view.dart';

import 'controllers/theme_controller.dart';
import 'core/init/locator/locator.dart';
import 'ui/screens/home/home_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  final _themeController = Get.put(ThemeController());
  await _themeController.updateThemeFromSharedPref();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  build(BuildContext context) {
    return GetMaterialApp(
      title: 'Note App',
      debugShowCheckedModeBanner: false,
      theme: getIt<ThemeController>().selectedTheme.value,
      getPages: [
        GetPage(
          name: '/',
          page: () => HomeView(),
        ),
        GetPage(
          name: '/note_view',
          page: () => NoteView(),
        ),
        GetPage(
          name: '/edit_view',
          page: () => EditView(),
        ),
        GetPage(
          name: '/photo_view',
          page: () => PhotoViewWidget(
            imagePath: '',
          ),
        ),
      ],
      initialRoute: '/',
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:note_app/controllers/database_controller.dart';
import 'package:note_app/core/init/locator/locator.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/service/database_service.dart';
import 'package:sqflite/sqflite.dart';

class HomeController extends GetxController {
  TextEditingController searchController = TextEditingController();
  var isFlagOn = false.obs;
  var isSearchEmpty = true.obs;
  var headerShouldHide = false.obs;
  var notesList = [].obs;
  var _dbController = Get.put(DataBaseController());

  @override
  Future<void> onInit() async {
    super.onInit();
    await initDb();
    setNotesFromDB();
  }

  initDb() async {
    await _dbController.init();
  }

  setNotesFromDB() async {
    notesList.value = await _dbController.getNotesFromDB();
    Logger()
        .w('NOTE LIST --> ${notesList.value.map((e) => (e as Note).toMap())}');
  }
}

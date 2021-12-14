import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/models/note.dart';

class EditController extends GetxController {
  late Note currentNote;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  var isDirty = false.obs;
  var isNoteNew = true.obs;
  var selectedImageFile = Rxn<File>();
}

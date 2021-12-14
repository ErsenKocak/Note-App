import 'package:get/get.dart';
import 'package:note_app/core/init/locator/locator.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/service/database_service.dart';

class DataBaseController extends GetxController {
  var _dbService = getIt<DatabaseService>();

  init() {
    _dbService.init();
  }

  Future<List<Note>> getNotesFromDB() async {
    return _dbService.getNotesFromDB();
  }

  updateNoteInDB(Note updatedNote) async {
    updatedNote.date = DateTime.now();
    _dbService.updateNoteInDB(updatedNote);
  }

  deleteNoteInDB(Note noteToDelete) async {
    _dbService.deleteNoteInDB(noteToDelete);
  }

  Future<Note> addNoteInDB(Note newNote) async {
    return _dbService.addNoteInDB(newNote);
  }
}

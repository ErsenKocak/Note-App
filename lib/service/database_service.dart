import 'package:logger/logger.dart';
import 'package:note_app/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // if _database is null we instantiate it
    _database = await init();
    return _database!;
  }

  init() async {
    String path = await getDatabasesPath();
    path = join(path, 'notes.db');

    return _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Notes (_id INTEGER PRIMARY KEY, title TEXT, content TEXT, date TEXT, isImportant INTEGER,imagePath TEXT);');
    });
  }

  Future<List<Note>> getNotesFromDB() async {
    final db = await database;
    List<Note> notesList = [];
    List<Map<String, dynamic>> maps = await db.query('Notes', columns: [
      '_id',
      'title',
      'content',
      'date',
      'isImportant',
      'imagePath'
    ]);
    if (maps.isNotEmpty) {
      maps.forEach((map) {
        notesList.add(Note.fromMap(map));
      });
    }
    return notesList;
  }

  updateNoteInDB(Note updatedNote) async {
    Logger().w('UPDATED NOTE  --> ${updatedNote.toMap()}');
    final db = await database;
    await db.update('Notes', updatedNote.toMap(),
        where: '_id = ?', whereArgs: [updatedNote.id]);
  }

  deleteNoteInDB(Note noteToDelete) async {
    final db = await database;
    await db.delete('Notes', where: '_id = ?', whereArgs: [noteToDelete.id]);
  }

  Future<Note> addNoteInDB(Note newNote) async {
    Logger().w('NEW NOTE --> ${newNote.toMap()}');
    final db = await database;
    if (newNote.title!.trim().isEmpty) newNote.title = 'Başlıksız Not';
    int id = await db.transaction((transaction) async {
      return await transaction.rawInsert(
          'INSERT into Notes(title, content, date, isImportant,imagePath) VALUES ("${newNote.title}", "${newNote.content}", "${newNote.date!.toIso8601String()}", ${newNote.isImportant == true ? 1 : 0}, "${newNote.imagePath}" );');
    });
    newNote.id = id;
    return newNote;
  }
}

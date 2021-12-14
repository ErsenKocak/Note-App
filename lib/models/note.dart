import 'dart:io';
import 'dart:math';

class Note {
  int? id;
  String? title;
  String? content;
  bool? isImportant;
  DateTime? date;
  String? imagePath;

  Note(
      {this.id,
      this.title,
      this.content,
      this.isImportant,
      this.date,
      this.imagePath});

  Note.fromMap(Map<String, dynamic> map) {
    id = map['_id'];
    title = map['title'];
    content = map['content'];
    date = DateTime.parse(map['date']);
    isImportant = map['isImportant'] == 1 ? true : false;
    imagePath = map['imagePath'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'title': title,
      'content': content,
      'isImportant': isImportant == true ? 1 : 0,
      'date': date!.toIso8601String(),
      'imagePath': imagePath
    };
  }
}

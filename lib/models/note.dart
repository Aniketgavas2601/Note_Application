import 'package:cloud_firestore/cloud_firestore.dart';

class NotesModel {
  String id;
  String title;
  String description;
  bool? isArchive;
  bool? isDeleted;

  NotesModel(
      {required this.id,
      required this.title,
      required this.description,
      this.isArchive,
      this.isDeleted});

  static NotesModel fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> e) {
    print("++++++++++++++++++++++++++++++++++++++++++++++++");

    final id = e.data()['id'];
    final title = e.data()['title'];
    final description = e.data()['description'];
    final isArchive = e.data()['isArchive'];
    final isDeleted = e.data()['isDeleted'];
    //print(title);
    print("==============================================$isArchive");

    return NotesModel(
        id: id,
        title: title,
        description: description,
        isArchive: isArchive,
        isDeleted: isDeleted);
  }
}

class LocalNoteModel {
  String id;
  String title;
  String description;
  bool isSynced;

  LocalNoteModel(this.id, this.title, this.description, this.isSynced);

  LocalNoteModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'],
        description = res['description'],
        isSynced = res['isSynced'] == 1 ? true : false;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isSynced': isSynced ? 1 : 0
    };
  }

  NotesModel convertToNotesModel() {
    return NotesModel(id: id, title: title, description: description);
  }
}

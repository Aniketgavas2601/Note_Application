import 'package:cloud_firestore/cloud_firestore.dart';

class NotesModel {
  String id;
  String title;
  String description;

  NotesModel({required this.id, required this.title, required this.description});

  static NotesModel fromQuerySnapshot(QueryDocumentSnapshot<Map<String,dynamic>> e) {
    print("++++++++++++++++++++++++++++++++++++++++++++++++");

    final id = e.data()['id'];
    final title = e.data()['title'];
    final description = e.data()['description'];
    final isArchived = e.data()['isArchived'];
    //print(title);
    print("==============================================");
    return NotesModel(id: id, title: title, description: description);
  }
}

class LocalNoteModel{
  String id;
  String title;
  String description;
  bool isSynced;

  LocalNoteModel(this.id, this.title, this.description, this.isSynced);

  LocalNoteModel.fromMap(Map<String,dynamic> res) :
        id = res['id'],
        title = res['title'],
        description = res['description'],
        isSynced = res['isSynced'] == 1 ? true : false;

  Map<String,dynamic> toMap(){

    return {
      'id': id,
      'title': title,
      'description': description,
      'isSynced': isSynced ? 1 : 0
    };
  }

  NotesModel convertToNotesModel(){
    return NotesModel(id: id, title: title, description: description);
  }
}

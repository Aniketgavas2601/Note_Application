import 'package:cloud_firestore/cloud_firestore.dart';

class NotesModel {
  String id;
  String title;
  String description;
  bool? isArchived;

  NotesModel({required this.id, required this.title, required this.description,this.isArchived});

  NotesModel copyWith(String id, String title, String description, bool? isArchived) => NotesModel(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    isArchived: isArchived ?? this.isArchived
  );

  static NotesModel fromQuerySnapshot(QueryDocumentSnapshot<Map<String,dynamic>> e) {
    print("++++++++++++++++++++++++++++++++++++++++++++++++");

    final id = e.data()['id'];
    final title = e.data()['title'];
    final description = e.data()['description'];
    final isArchived = e.data()['isArchived'];
    //print(title);
    print("==============================================");
    return NotesModel(id: id, title: title, description: description, isArchived: false);
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
  //isArchived = res['isArchived'];

  Map<String,dynamic> toMap(){

    return {
      'id': id,
      'title': title,
      'description': description,
      'isSynced': isSynced ? 1 : 0
      //'isArchived': isArchived
    };
  }

  NotesModel convertToNotesModel(){
    return NotesModel(id: id, title: title, description: description);
  }
}

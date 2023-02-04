import 'package:cloud_firestore/cloud_firestore.dart';

class NotesModel {
  String? id;
  String? title;
  String? description;

  NotesModel(this.id, this.title, this.description);

  static NotesModel fromQuerySnapshot(QueryDocumentSnapshot<Map<String,dynamic>> e){
    print("++++++++++++++++++++++++++++++++++++++++++++++++");

    final id = e.data()['id'];
    final title = e.data()['title'];
    final description = e.data()['description'];
    //print(title);
    print("==============================================");
    return NotesModel("id", "title", "description",);
  }
}

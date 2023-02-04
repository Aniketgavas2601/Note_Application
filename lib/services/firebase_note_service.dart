import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_app/models/note.dart';

class FirebaseNoteService{
  static final  ref = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('notes');
  
  // static Future<void> addNote(String title, String description) async {
  //   await document.set({
  //     'id': document.id,
  //     'title': title,
  //     'description': description,
  //   });
  //   // ref.add({
  //   //   'title': title,
  //   //   'description': description,
  //   // });
  // }

  static Future<void> addNote(String title, String description) async{
    DocumentReference document = ref.doc();
    await ref.doc(document.id).set({
      'id': document.id,
      'title': title,
      'description': description
    });
  }

  static Future<void> updateNote(String docId, String title, String description) async {
    try{
      await ref.doc(docId).update({
        'title': title,
        'description': description,
      });
    }catch(e){
      print(e);
    }
  }

  static Future<void> deleteNote(String docId) async{
    try{
      await ref.doc(docId).delete();
    }catch(e){
      print(e);
    }
  }

  static List<NotesModel> list = [];

  static fetchNotes() async {
    final snapshot = await ref.get();
    print("**************************************************${snapshot.docs.length}");
     snapshot.docs.forEach((element) {
       final note = NotesModel.fromQuerySnapshot(element);
       list.add(note);
     });
     //print("######################################${list.toString()}");
  }
}
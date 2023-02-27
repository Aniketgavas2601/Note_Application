import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_app/models/note.dart';
import 'package:uuid/uuid.dart';

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

  static Future<String> addNote(String title, String description) async{

    final uuid = Uuid().v4();

    DocumentReference document = ref.doc(uuid);
    await ref.doc(uuid).set({
      'id': uuid,
      'title': title,
      'description': description,
      'date': DateTime.now()
    });
    return uuid;
  }

  static Future<void> updateNote(NotesModel notesModel) async {
    try{
      await ref.doc(notesModel.id).update({
        'title': notesModel.title,
        'description': notesModel.description,
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

  static Future<void> updateFirestoreWithLocalDb(NotesModel notesModel) async {
    DocumentReference document = ref.doc(notesModel.id);
    await ref.doc(notesModel.id).set({
      'id': notesModel.id,
      'title': notesModel.title,
      'description': notesModel.description,
      'date': DateTime.now()
    });
  }

  static List<NotesModel> list = [];

  // static fetchNotes() async {
  //   final snapshot = await ref.get();
  //   print("**************************************************${snapshot.docs.length}");
  //    snapshot.docs.forEach((element) {
  //      final note = NotesModel.fromQuerySnapshot(element);
  //      list.add(note);
  //    });
  //    //print("######################################${list.toString()}");
  // }
 }
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_app/models/note.dart';
import 'package:uuid/uuid.dart';

class FirebaseNoteService{
  FirebaseNoteService._();
  static final instance =  FirebaseNoteService._();


  static final  ref = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('notes');

  static Future<String> addNote(String title, String description, bool isArchive, bool isDeleted) async{

    final uuid = Uuid().v4();

    //DocumentReference document = ref.doc(uuid);
    final document = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('notes');
    var data = {
      'id': uuid,
      'title': title,
      'description': description,
      'date': DateTime.now(),
      'isArchive': isArchive,
      'isDeleted': isDeleted
    };

    await document.doc(uuid).set(
      data
    );
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
      final document = await ref.doc(docId);
      await document.update({
        'isDeleted': true,
      });
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

  //update the data is archive or not
  Future<void> updateIsArchived(NotesModel notesModel) async {
    log(notesModel.isArchive.toString());
    final isArchive = notesModel.isArchive ?? false;
    log("inside Archive Method");
    log(isArchive.toString());

    var data = {
      'id': notesModel.id,
      'title': notesModel.title,
      'description': notesModel.description,
      'date': DateTime.now(),
      'isArchive': !isArchive,
      'isDeleted': notesModel.isDeleted
    };

    await ref.doc(notesModel.id).update(data);
  }
 }
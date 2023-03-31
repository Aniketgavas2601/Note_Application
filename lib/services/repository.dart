import 'dart:developer';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:login_app/models/note.dart';
import 'package:login_app/services/firebase_note_service.dart';
import 'package:login_app/services/sqlite_database.dart';
import 'package:login_app/utils/internet_connection.dart';
import 'package:uuid/uuid.dart';



class Repository {
  Repository._();
  static final instance = Repository._();

  Future<void> addNote(String title, String description, DateTime date, bool isArchive, bool isDeleted) async {
    if(InternetConnection.instance.isDeviceConnected){
      print("########################");
      final id = await FirebaseNoteService.addNote(title, description, isArchive,isDeleted);
      final localNoteModel = LocalNoteModel(id, title, description, true);
      SqlFliteService.instance.insert(localNoteModel);
    }else{
      print("&&&&&&&&&&&&&&&&&&&&&&&&");
      final uuid = Uuid().v4();
      final localNoteModel = LocalNoteModel(uuid, title, description, false);
      SqlFliteService.instance.insert(localNoteModel);
    }
  }

  Future<void> deleteNote(String id) async {
    FirebaseNoteService.deleteNote(id).then((_) {
      log('before delete');
      SqlFliteService.instance.delete(id);
    });
  }

  Future<void> updateNote(NotesModel notesModel) async {
    FirebaseNoteService.updateNote(notesModel).then((_)  {
      final localNoteModel = LocalNoteModel(notesModel.id, notesModel.title, notesModel.description, true);
      SqlFliteService.instance.update(localNoteModel);

    });
  }

  Future<void> updateIsArchived(NotesModel notesModel) async {
    await FirebaseNoteService.instance.updateIsArchived(notesModel);
  }
}
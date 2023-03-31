import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_app/models/note.dart';
import 'package:login_app/services/repository.dart';
import 'package:login_app/widgets/note_list.dart';

class ArchiveNotes extends StatefulWidget {


  @override
  State<ArchiveNotes> createState() => _ArchiveNotesState();
}

class _ArchiveNotesState extends State<ArchiveNotes> {
  Future<List<NotesModel>>? fetchNotes() async {
    final ref = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('notes');
    return await ref.
    where('isDeleted', isEqualTo: false).where('isArchive', isEqualTo: true).
    get().then((snapshot) {
      return snapshot.docs.map((e) => NotesModel.fromQuerySnapshot(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Archive Note'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<NotesModel>>(
        future: fetchNotes(),
        builder: (context, AsyncSnapshot<List<NotesModel>> snapshot){
          final notes = snapshot.data ?? [];
          return NoteList(noteList: notes,callback: (note){

          },onLongPress: (note) async {
            await Repository.instance.updateIsArchived(note);
            setState(() {

            });
          },
          );
        },
      ),
    );
  }
}

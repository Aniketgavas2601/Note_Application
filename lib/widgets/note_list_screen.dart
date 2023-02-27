import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_app/models/note.dart';
import 'package:login_app/views/editnotes.dart';



class NoteList extends StatelessWidget {


  final List<NotesModel> noteList;

  final Function(NotesModel) callback;

  const NoteList({super.key, required this.noteList, required this.callback});


  @override
  Widget build(BuildContext context) {
    log(FirebaseAuth.instance.currentUser!.uid);

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(itemBuilder: (context,index){
        final note = noteList[index];
        return GestureDetector(
          onTap: (){
            callback(note);
          },
          child: Card(
            color: Colors.lightGreen,
            child: ListTile(
              //title: Text(snapshot.data!.docs[index].get('title')),
              title: Text(note.title ?? ""),
              subtitle: Text(note.description ?? ""),
            ),
          ),
        );
      },
        itemCount: noteList.length,
      )
    );
  }
}
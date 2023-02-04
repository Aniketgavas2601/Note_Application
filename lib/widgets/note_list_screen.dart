import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_app/models/note.dart';
import 'package:login_app/views/editnotes.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});


  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('notes').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          return ListView.builder(itemBuilder: (context,index){
            return GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => EditNotes(docToEdit: snapshot.data!.docs[index])));
              },
              child: ListTile(
                title: Text(snapshot.data!.docs[index].get('title')),
                subtitle: Text(snapshot.data!.docs[index].get('description')),
              ),
            );
          },
            itemCount: snapshot.hasData ? snapshot.data!.docs.length : 0,
          );
        },
      ),
    );
  }
 }
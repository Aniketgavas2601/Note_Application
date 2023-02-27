import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_app/models/note.dart';
import 'package:login_app/widgets/note_list_screen.dart';

class SearchNotes extends StatefulWidget {
  const SearchNotes({Key? key}) : super(key: key);

  @override
  State<SearchNotes> createState() => _SearchNotesState();
}

class _SearchNotesState extends State<SearchNotes> {

  List<NotesModel> searchResult = [];

  void searchFromFirebase(String query) async {
    
    final result = await FirebaseFirestore.instance.collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid).collection('notes')
        .where('title',isGreaterThanOrEqualTo: query)
        .get();

    setState(() {
      searchResult = result.docs.map((e) => NotesModel.fromQuerySnapshot(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search here',
          ),
          style: const TextStyle(
            color: Colors.black54
          ),
          onChanged: (query){
             searchFromFirebase(query);
          },
        ),
        actions: [
          IconButton(onPressed: (){
            
          }, icon: const Icon(Icons.search)),
        ],
      ),
      body: NoteList(noteList: searchResult,callback: (searchNote){

      },)

    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchNotes extends StatefulWidget {
  const SearchNotes({Key? key}) : super(key: key);

  @override
  State<SearchNotes> createState() => _SearchNotesState();
}

class _SearchNotesState extends State<SearchNotes> {

  List searchResult = [];

  void searchFromFirebase(String query) async {
    
    final result = await FirebaseFirestore.instance.collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid).collection('notes')
        .where('title',isGreaterThanOrEqualTo: query)
        .get();

    setState(() {
      searchResult = result.docs.map((e) => e.data()).toList();
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
      body: ListView.builder(
          itemCount: searchResult.length,
          itemBuilder: (context, index){
            return GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, 'homePage');
              },
              child: ListTile(
                title: Text(searchResult[index]['title']),
                subtitle: Text(searchResult[index]['description']),
              ),
            );
      })
    );
  }
}

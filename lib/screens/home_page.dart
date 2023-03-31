import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:login_app/models/note.dart';
import 'package:login_app/screens/sidebar_menu.dart';
import 'package:login_app/services/firebase_auth_service.dart';
import 'package:login_app/services/repository.dart';
import 'package:login_app/views/editnotes.dart';
import 'package:login_app/views/search_notes.dart';
import 'package:login_app/widgets/note_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Icon customIcon = const Icon(Icons.search);

  Widget customSearch = const Text('Notion');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuthService.savedSessionKey();

    //gives you the message on which user taps and it open the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if(message != null){
        final routeMessage = message.data["route"];

        Navigator.pushNamed(context, routeMessage);
      }
    });
    //foreground
    FirebaseMessaging.onMessage.listen((message) {
      if(message.notification != null){
        print(message.notification!.body);
        print(message.notification!.title);
      }
    });

    // it works when user tap on the notification in the notification tray
    // it works only when app is not terminated from background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeMessage = message.data["route"];
      Navigator.pushNamed(context, routeMessage);
      print(routeMessage);
    });
  }


  Future<List<NotesModel>>? fetchNotes() async {
    print("fetch");
    final ref = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('notes');
    return await ref.
    where('isDeleted', isEqualTo: false).where('isArchive', isEqualTo: false).
    get().then((snapshot) async {
      print("snapshot");
      return await snapshot.docs.map((e) => NotesModel.fromQuerySnapshot(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      onDrawerChanged: (isClosed){
        log("on change Drawer is $isClosed");
        if(!isClosed){
          setState(() {
            
          });
        }
      },
      drawer: NavBar(),
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchNotes()));
              },
              icon: customIcon),
          TextButton(
              onPressed: () {
                try {
                  FirebaseAuthService.autoLogin();
                  if (mounted) {
                    Navigator.pushNamed(context, 'login');
                  }
                } catch (e) {
                  print(e);
                }
              },
              child: const Icon(
                Icons.logout,
                color: Colors.white,
              )),
        ],
        title: customSearch,
      ),
      body: FutureBuilder<List<NotesModel>>(
        future: fetchNotes(),
        builder: (context, AsyncSnapshot<List<NotesModel>> snapshot){
          final notes = snapshot.data ?? [];
          return NoteList(noteList: notes,callback: (note) async {
            await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                EditNotes(note: note)
            ));
            setState(() {

            });
          },onLongPress: (note) async {
            await Repository.instance.updateIsArchived(note);
            setState(() {

            });
          },
          );

        },
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightBlueAccent,
          child: const Icon(Icons.add),
          onPressed: () async {
           final result = await Navigator.pushNamed(context, 'addNotes');
           print(result);
           setState(() {

           });
          }),
      backgroundColor: Colors.transparent,
    );
  }
}

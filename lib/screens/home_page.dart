import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:login_app/models/note.dart';
import 'package:login_app/screens/sidebar_menu.dart';
import 'package:login_app/services/firebase_auth_service.dart';
import 'package:login_app/views/editnotes.dart';
import 'package:login_app/views/search_notes.dart';
import 'package:login_app/widgets/note_list_screen.dart';

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
    //FirebaseNoteService.fetchNotes();
    //setState(() {});

  }

  // void savedSessionKey() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   preferences.setBool('isLoggedIn', true);
  // }

  //List<NotesModel> noteList = [];

  Future<List<NotesModel>>? fetchNotes() async {
    return await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('notes').get().then((snapshot) {
      return snapshot.docs.map((e) => NotesModel.fromQuerySnapshot(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                // FirebaseAuth.instance.signOut().then((value) async {
                // SharedPreferences preferences = await SharedPreferences.getInstance();
                // preferences.setBool('isLoggedIn', false);
                //   if (mounted) {
                //     Navigator.pushNamed(context, 'login');
                //   }
                // }).catchError((e) {
                //   print(e);
                // });
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
          },);
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

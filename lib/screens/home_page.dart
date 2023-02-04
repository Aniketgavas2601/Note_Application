import 'package:flutter/material.dart';
import 'package:login_app/screens/sidebar_menu.dart';
import 'package:login_app/services/firebase_auth_service.dart';
import 'package:login_app/services/firebase_note_service.dart';
import 'package:login_app/views/search_notes.dart';
import 'package:login_app/widgets/note_list_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  NoteList noteList = NoteList();

  Icon customIcon = const Icon(Icons.search);

  Widget customSearch = const Text('Notion');



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuthService.savedSessionKey();
    FirebaseNoteService.fetchNotes();
    setState(() {

    });
  }

  // void savedSessionKey() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   preferences.setBool('isLoggedIn', true);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchNotes()));
              },
              icon: customIcon),
          TextButton(
              onPressed: () {
                try{
                FirebaseAuthService.autoLogin();
                  if(mounted){
                    Navigator.pushNamed(context, 'login');
                  }
                }catch(e){
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
      body: const NoteList(),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightBlueAccent,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, 'addNotes');
          }),
      backgroundColor: Colors.transparent,
    );
  }
}

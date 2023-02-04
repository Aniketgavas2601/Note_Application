import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_app/screens/add_note_screen.dart';
import 'package:login_app/screens/login.dart';
import 'package:login_app/screens/register.dart';
import 'package:login_app/screens/home_page.dart';
import 'package:login_app/widgets/note_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// void main() => runApp(MaterialApp(
//   debugShowCheckedModeBanner: false,
//   initialRoute: 'login',
//   routes: {
//     'login': (context) => MyLogin(),
//     'register': (context) => MyRegister(),
//     'logout' : (context) => LogOut()
//   },
// ));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool isLoggedIn = preferences.getBool("isLoggedIn") ?? false;
  //print(isLoggedIn);
  runApp(MyApp(isLoggedIn: isLoggedIn,));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.isLoggedIn,}) : super(key: key);

  final bool isLoggedIn;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: isLoggedIn ? 'homePage' : 'login',
      routes: {
        'login': (context) => const MyLogin(),
        'register': (context) => const MyRegister(),
        'homePage': (context) => const HomePage(),
        'addNotes': (context) =>  const AddNotes(),
        'noteList': (context) => const NoteList()
      },
    );
  }
}

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../storage/storage_file.dart';



class FirebaseAuthService {

  static Future<String> signIn(String email, String password) async {
    try{
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: email, password: password);
      return 'Successfully login';
    }catch(e){
      print(e);
      return "something wrong";
    }
  }
  static Future<String> signUp(String name, String email, String password, Uint8List? image) async {
    try{
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: email, password: password)
          .then(
            (signedInUser) async {
          if (signedInUser.user != null) {
            final imageUrl = await StorageMethods()
                .uploadImageStorage(
                "profileImage", image!);
            print(imageUrl);

            FirebaseFirestore.instance.collection('users').add({
              'name': name,
              'email': email,
              'pass': password,
              'imageUrl': imageUrl
            });
          }
        },
      );
      return 'Success';
    }catch(e){
      print(e);
      return 'Something Wrong';
    }
  }

  static Future<void> savedSessionKey() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('isLoggedIn', true);
  }

  static Future<void> autoLogin() async{
    FirebaseAuth.instance.signOut().then((value) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setBool('isLoggedIn', false);
    });
  }
}
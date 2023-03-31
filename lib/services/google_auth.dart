import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn googleSignIn = GoogleSignIn();
CollectionReference users = FirebaseFirestore.instance.collection('users');
final FirebaseAuth auth = FirebaseAuth.instance;

Future<bool?> signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();                              // pop up to choose your google account

    if (googleSignInAccount != null) {
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;              //getting authentication details

      final AuthCredential credential = GoogleAuthProvider.credential(          //create a new credential
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);
      final UserCredential authResult =
          await auth.signInWithCredential(credential);       //return the user credential

      final User? user = authResult.user;

      var userData = {
        'name': googleSignInAccount.displayName,
        'provider': 'google',
        'email': googleSignInAccount.email
      };

      //uid
      users.doc(user!.uid).get().then((doc) {
        if (doc.exists) {
          //old user
          doc.reference.update(userData);

          Navigator.pushNamed(context, 'homePage');
        } else {
          //new user
          users.doc(user.uid).set(userData);
          Navigator.pushNamed(context, 'homePage');
        }
      });
    }
  } catch (PlatformException) {
    print(PlatformException);
    print("Sign In Not Successful !");
  }
}

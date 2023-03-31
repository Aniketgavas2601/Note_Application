import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_app/screens/archive_notes.dart';
import 'package:login_app/screens/web_view_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NavBar extends StatefulWidget {
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final user = FirebaseAuth.instance.currentUser;

  String? profilePic;

  Future<void> fetchProfileImage() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) {
      final data = snapshot.data();
      if(data != null){
        print(data['imageUrl']);
        //print(snapshot['imageUrl']);
        setState(() {
          profilePic = data['imageUrl'];
        });
      }
    });
  }

  @override
  void initState() {
    fetchProfileImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.lightBlueAccent,
            child: Center(
              child: Column(
                children: <Widget>[
                profilePic != null ? CachedNetworkImage(
                      imageUrl: profilePic!,
                      imageBuilder: (context, imageProvider) =>  Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(top: 30),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fill
                          ),
                        ),
                      ),
                    placeholder: (context,url) => const Center(child: CircularProgressIndicator(),),
                  ) : Container(),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    user!.email.toString(),
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          Column(
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ArchiveNotes()));
                },
                child: const ListTile(
                  leading: Icon(Icons.archive),
                  title: Text('Archive'),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => WebView()));
                },
                child: const ListTile(
                  leading: Icon(Icons.info),
                  title: Text(
                    'about',
                    style: TextStyle(color: Colors.black54, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

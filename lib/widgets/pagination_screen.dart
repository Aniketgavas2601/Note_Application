import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_app/views/editnotes.dart';

class PaginationScreen extends StatefulWidget {
  const PaginationScreen({Key? key}) : super(key: key);

  @override
  State<PaginationScreen> createState() => _PaginationScreenState();
}

class _PaginationScreenState extends State<PaginationScreen> {

  CollectionReference ref = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('notes');
  DocumentSnapshot? lastDocument;
  bool isMoreData = true;
  List<Map<String, dynamic>> list = [];
  final ScrollController controller = ScrollController();
  bool isLoadingData = false;

  @override
  void initState() {
    super.initState();
    paginatedData();
    controller.addListener(() {
      //controller.position.pixels gives the current position
      //controller.position.maxScrollExtent it holds and returns the max value up to which we can scroll
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        paginatedData();
      }
    });
  }

  void paginatedData() async {
    if (isMoreData) {
      setState(() {
        isLoadingData = true;
      });
      final ref = this.ref;
      late QuerySnapshot<Map<String, dynamic>>? querySnapshot;
      if (lastDocument == null) {
        querySnapshot =
        (await ref.limit(10).get()) as QuerySnapshot<Map<String, dynamic>>?;

      } else {
        querySnapshot = (await ref
            .limit(10)
            .startAfterDocument(lastDocument!)
            .get()) as QuerySnapshot<Map<String, dynamic>>?;
      }

      if (querySnapshot!.docs.isNotEmpty) {
        print("...........................");
        lastDocument = querySnapshot.docs.last;
      }


      list.addAll(querySnapshot.docs.map((e) => e.data()));
      setState(() {isLoadingData = false;});
      if (querySnapshot.docs.length < 10) {
        isMoreData = false;
      }
    } else {
      log("No more data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: controller,
              itemCount: list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => EditNotes(docToEdit: snapshot.data!.docs[index])));
                  },
                  title: Text(list[index]['title'].toString()),
                  subtitle: Text(list[index]['description'].toString()),
                );
              },
            ),
          ),
          isLoadingData
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : const SizedBox(),
        ],
      ),
    );
  }
}

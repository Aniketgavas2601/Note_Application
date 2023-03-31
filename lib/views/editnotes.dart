import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login_app/models/note.dart';
import 'package:login_app/services/firebase_note_service.dart';
import 'package:login_app/services/repository.dart';

class EditNotes extends StatefulWidget {

  //DocumentSnapshot docToEdit;

  //EditNotes({super.key, required this.docToEdit});
  NotesModel note;

  EditNotes({super.key, required this.note});

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {

  TextEditingController newNoteTitle = TextEditingController();
  TextEditingController newDescription = TextEditingController();

  @override
  void initState() {
    newNoteTitle.text = widget.note.title.toString();
    newDescription.text = widget.note.description.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff757575),
      child: Container(
        color: Colors.white,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightBlueAccent,
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () async {

                    // widget.docToEdit.reference.update({
                    //   'title': newNoteTitle.text,
                    //     'description': newDescription.text,
                    //   }).whenComplete(() {
                    //     Navigator.pop(context);
                    //   },
                    // );
                    // await FirebaseFirestore.instance.collection('users').add({
                    //   'title': newNoteTitle.text,
                    //   'description': newDescription.text,
                    // }).whenComplete(() {
                    //   Navigator.pop(context);
                    // });
                    //FirebaseNoteService.updateNote(widget.docToEdit.reference.id, newNoteTitle.text, newDescription.text);
                    final notesModel = NotesModel(id: widget.note.id, title: newNoteTitle.text, description: newDescription.text);
                    Repository.instance.updateNote(notesModel);

                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent
                  ),
                  child: const Text('save')),


              ElevatedButton(onPressed: () async {
                //widget.docToEdit.reference.delete().whenComplete(() => Navigator.pop(context));
                //FirebaseNoteService.deleteNote(widget.docToEdit.reference.id);
                Repository.instance.deleteNote(widget.note.id.toString()).then((value){
                  if(mounted){
                    Navigator.pop(context);
                  }
                });
              },style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent
              ),
                child: const Text('Delete'),)
            ],
          ),
          body: Container(
            padding: const EdgeInsets.only(right: 20,left: 20,top: 50),
            child: ListView(
              children: <Widget>[
                TextField(
                  controller: newNoteTitle,
                  autofocus: true,
                  decoration: InputDecoration(
                      hintText: 'title',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)
                      )
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: newDescription,
                  autofocus: true,
                  maxLines: 4,
                  decoration: InputDecoration(
                      hintText: 'Description',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)
                      )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

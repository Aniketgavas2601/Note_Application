import 'package:flutter/material.dart';
import 'package:login_app/services/firebase_note_service.dart';
import 'package:login_app/services/notification_service.dart';
import 'package:login_app/services/repository.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  TextEditingController newNoteTitle = TextEditingController();
  TextEditingController newDescription = TextEditingController();
  bool isArchive = false;
  bool isDeleted = false;

  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    notificationServices.initializedSettings();
    notificationServices.checkForNotification();
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
                    await Repository.instance.addNote(
                            newNoteTitle.text, newDescription.text, DateTime.now(),isArchive,isDeleted)
                        .whenComplete(() {
                      Navigator.pop(context, true);
                      //notificationServices.sendNotification('Notion', 'Your Note has been added');
                      //NotificationServices.showNotification('Notion', 'Your Note has been added');
                    });
                  },
                  child: const Text('Add')),
            ],
          ),
          body: Container(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 50),
            child: ListView(
              children: <Widget>[
                TextField(
                  controller: newNoteTitle,
                  autofocus: true,
                  decoration: InputDecoration(
                      hintText: 'title',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
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
                          borderRadius: BorderRadius.circular(20))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

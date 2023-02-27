import 'package:flutter/material.dart';

class ReminderNoteScreen extends StatefulWidget {
  const ReminderNoteScreen({Key? key}) : super(key: key);

  @override
  State<ReminderNoteScreen> createState() => _ReminderNoteScreenState();
}

class _ReminderNoteScreenState extends State<ReminderNoteScreen> {

  TimeOfDay? time;
  TimeOfDay? picked;

  @override
  void initState() {

    super.initState();
    time = TimeOfDay.now();
  }

  Future selectTime(BuildContext context) async {
    picked = await showTimePicker(
        context: context,
        initialTime: time!,
    );

    if(picked != null){
      setState(() {
        time = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder Notes'),
      ),
      body: Center(
        child: Column(
          children: [
            IconButton(onPressed: (){
              selectTime(context);
              print(time);
            }, icon: Icon(Icons.notifications)),
            Text('Time ${time!.hour}:${time!.minute}',style: TextStyle(fontSize: 25),)
          ],
        ),
      ),
    );
  }
}

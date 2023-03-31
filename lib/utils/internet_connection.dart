import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:login_app/services/firebase_note_service.dart';
import 'package:login_app/services/sqlite_database.dart';

class InternetConnection{
  bool isDeviceConnected = false;
  InternetConnection._(){
    _configureListener();
  }
  static final instance = InternetConnection._();
  void _configureListener() =>
      Connectivity().onConnectivityChanged.listen(
            (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (isDeviceConnected) {
            // log('Connected to internet');
            // final notes = await SqlFliteService.instance.getAsyncNotesList();
            // for(var note in notes){
            //   await FirebaseNoteService.updateFirestoreWithLocalDb(note.convertToNotesModel());
            // }
          }else{
            log('not Connected to internet');
          }
        },
      );
}

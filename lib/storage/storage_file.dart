import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods{
  final FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  //Function for add image to firebase storage
  Future<String> uploadImageStorage(String childName,Uint8List file) async {
    
    Reference ref = storage.ref().child(childName).child(auth.currentUser!.uid);
    
    UploadTask uploadTask = ref.putData(file);
    
    uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();

    return downloadUrl;
    print('1111111111111111111111111111111111111111111111111111111111111111111111111111111');
    print(downloadUrl);
    print('1111111111111111111111111111111111111111111111111111111111111111111111111111111');
  }
}
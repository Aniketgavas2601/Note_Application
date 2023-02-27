import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String? id;
  String? name;
  String? email;
  String? imageUrl;

  UserModel({required this.id,required this.name,required this.email,required this.imageUrl});

  static UserModel fromQuerySnapshot(QueryDocumentSnapshot<Map<String, dynamic>> e){
    final id = e.data()['id'];
    final name = e.data()['name'];
    final email = e.data()['email'];
    final imageUrl = e.data()['imageUrl'];

    return UserModel(id: id, name: name, email: email, imageUrl: imageUrl);
  }
}
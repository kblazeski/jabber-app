import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String id;
  final String email;
  final String? imageUrl;
  final String username;

  UserData({
    required this.id,
    required this.email,
    this.imageUrl,
    required this.username,
  });

  // Factory Method
  static UserData fromDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot,
  ) {
    var id = documentSnapshot.id;
    var email = documentSnapshot['email'];
    var username = documentSnapshot['username'];
    var imageUrl = documentSnapshot.data().containsKey('image_url')
        ? documentSnapshot['image_url']
        : null;

    return UserData(
        id: id, email: email, username: username, imageUrl: imageUrl);
  }
}

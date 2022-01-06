import 'package:cloud_firestore/cloud_firestore.dart';

class MessageData {
  final String id;
  final String text;
  final Timestamp createdAt;
  final String userId;
  final String username;
  final String? userImage;

  MessageData({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.userId,
    required this.username,
    this.userImage,
  });

  // Factory Method
  static MessageData fromDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot,
  ) {
    var id = documentSnapshot.id;
    var text = documentSnapshot['text'];
    var username = documentSnapshot['username'];
    var userId = documentSnapshot['userId'];
    var createdAt = documentSnapshot['createdAt'];
    var userImage = documentSnapshot.data().containsKey('userImage')
        ? documentSnapshot['userImage']
        : null;

    return MessageData(
      id: id,
      text: text,
      username: username,
      userId: userId,
      createdAt: createdAt,
      userImage: userImage,
    );
  }
}

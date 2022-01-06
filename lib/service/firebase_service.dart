import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  static late CollectionReference<Map<String, dynamic>> _chatEndpointForUsers;

  static Future<CollectionReference<Map<String, dynamic>>>
      setEndPointForUsersChat(
    String currentUserId,
    String selectedUserId,
  ) async {
    final firstVariation = '${currentUserId}${selectedUserId}';
    final secondVariation = '${selectedUserId}${currentUserId}';

    final firstVariationEndpoint = FirebaseFirestore.instance
        .collection('chats')
        .doc(firstVariation)
        .collection('messages');
    final secondVariationEndpoint = FirebaseFirestore.instance
        .collection('chats')
        .doc(secondVariation)
        .collection('messages');

    final firstVariationSnapshot = await firstVariationEndpoint.get();
    final secondVariationSnapshot = await secondVariationEndpoint.get();

    CollectionReference<Map<String, dynamic>> endPointChat;

    if (firstVariationSnapshot.docs.isNotEmpty) {
      endPointChat = firstVariationEndpoint;
    } else if (secondVariationSnapshot.docs.isNotEmpty) {
      endPointChat = secondVariationEndpoint;
    } else {
      endPointChat = FirebaseFirestore.instance
          .collection('chats')
          .doc(firstVariation)
          .collection("messages");
    }

    _chatEndpointForUsers = endPointChat;

    return endPointChat;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getChatMessages() {
    return _chatEndpointForUsers
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots();
  }

  static void signOutUser() {
    FirebaseAuth.instance.signOut();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUsers(
      String? searchText) {
    var usersCollection = FirebaseFirestore.instance.collection("users");
    var usersQuery = usersCollection.limit(10);
    if (searchText != null) {
      usersQuery = usersCollection
          .where('username', isGreaterThanOrEqualTo: searchText)
          .where('username', isLessThan: '${searchText}z')
          .limit(10);
    }
    var usersQueryStream = usersQuery.snapshots();

    return usersQueryStream;
  }

  static void addNewMessageToChat(String message) async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    var messageMap = {
      'text': message,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
    };

    if (userData.data()!.containsKey('image_url')) {
      messageMap.putIfAbsent('userImage', () => userData['image_url']);
    }

    _chatEndpointForUsers.add(messageMap);
  }

  static Future<UserCredential> createUser(
    String email,
    String password,
    File? image,
    String userName,
  ) async {
    UserCredential authResult =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    var userMap = {'username': userName, 'email': email};
    String? imageUrl;

    if (image != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child(authResult.user!.uid + '.jpg');

      final uploadTask = ref.putFile(image);

      imageUrl = await (await uploadTask).ref.getDownloadURL();
      userMap.putIfAbsent('image_url', () => imageUrl!);
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(authResult.user!.uid)
        .set(userMap);

    return authResult;
  }

  static User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  static bool isCurrentUser(String userId) {
    return userId == FirebaseAuth.instance.currentUser!.uid;
  }
}

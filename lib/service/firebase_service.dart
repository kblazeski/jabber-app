import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUsers(int? numLimit) {
    var usersCollection = FirebaseFirestore.instance.collection("users");
    var usersCollectionStream;
    if (numLimit != null) {
      usersCollectionStream = usersCollection.limit(numLimit).snapshots();
    } else {
      usersCollectionStream = usersCollection.snapshots();
    }
    return usersCollectionStream;
  }

  static void addNewMessageToChat(String message) async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    _chatEndpointForUsers.add(
      {
        'text': message,
        'createdAt': Timestamp.now(),
        'userId': user!.uid,
        'username': userData['username'],
        'userImage': userData['image_url']
      },
    );
  }

  static User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  static bool isCurrentUser(String userId) {
    return userId == FirebaseAuth.instance.currentUser!.uid;
  }
}

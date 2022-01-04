import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:jabber_app/screens/chat_screen.dart';
import 'package:jabber_app/widgets/chat/messages.dart';
import 'package:jabber_app/widgets/user/user_card.dart';

class Users extends StatelessWidget {
  const Users({Key? key}) : super(key: key);

  void selectUserToChatWith(String selectedUserId, BuildContext context) {
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;
    var endpointForChatMessages =
        getEndpointForAddingUserChat(currentUserId, selectedUserId);
    endpointForChatMessages.then((endPoint) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(messagesEndpoint: endPoint),
        ),
      );
    });
  }

  Future<CollectionReference<Map<String, dynamic>>>
      getEndpointForAddingUserChat(
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

    CollectionReference<Map<String, dynamic>> endPointForAddingMessage;

    if (firstVariationSnapshot.docs.isNotEmpty) {
      endPointForAddingMessage = firstVariationEndpoint;
    } else if (secondVariationSnapshot.docs.isNotEmpty) {
      endPointForAddingMessage = secondVariationEndpoint;
    } else {
      endPointForAddingMessage = FirebaseFirestore.instance
          .collection('chats')
          .doc(firstVariation)
          .collection("messages");
    }

    return endPointForAddingMessage;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream:
          FirebaseFirestore.instance.collection('users').limit(10).snapshots(),
      builder: (ctx, usersSnapshot) {
        if (usersSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final userDocs = usersSnapshot.data!.docs;
        return ListView.builder(
          reverse: false,
          itemCount: userDocs.length,
          itemBuilder: (ctx, index) =>
              // extract the user checking
              FirebaseAuth.instance.currentUser!.uid != userDocs[index].id
                  ? UserCard(
                      key: ValueKey(userDocs[index].id),
                      userId: userDocs[index].id,
                      username: userDocs[index]['username'],
                      userPicture: userDocs[index]['image_url'],
                      selectUserForChatting: selectUserToChatWith,
                    )
                  : SizedBox.shrink(),
        );
      },
    );
  }
}

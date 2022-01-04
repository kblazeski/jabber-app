import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:jabber_app/service/firebase_service.dart';
import 'package:jabber_app/screens/chat_screen.dart';
import 'package:jabber_app/widgets/chat/messages.dart';
import 'package:jabber_app/widgets/user/user_card.dart';

class Users extends StatelessWidget {
  const Users({Key? key}) : super(key: key);

  void selectUserToChatWith(dynamic selectedUser, BuildContext context) async {
    var currentUserId = FirebaseService.getCurrentUser()!.uid;
    await FirebaseService.setEndPointForUsersChat(
      currentUserId,
      selectedUser.id,
    );

    // navigate to the chat screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ChatScreen(userToChatWithName: selectedUser['username']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseService.getUsers(10),
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
            itemBuilder: (ctx, index) {
              var user = userDocs[index];
              return !FirebaseService.isCurrentUser(user.id)
                  ? UserCard(
                      key: ValueKey(user.id),
                      user: user,
                      selectUserForChatting: selectUserToChatWith,
                    )
                  : SizedBox.shrink();
            }
            // extract the user checking

            );
      },
    );
  }
}

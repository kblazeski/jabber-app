import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:jabber_app/models/user_data.dart';
import 'package:jabber_app/service/firebase_service.dart';
import 'package:jabber_app/screens/chat_screen.dart';
import 'package:jabber_app/widgets/chat/messages.dart';
import 'package:jabber_app/widgets/user/user_card.dart';
import 'package:jabber_app/models/user_data.dart';

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  String? searchUserText;

  void selectUserToChatWith(UserData selectedUser, BuildContext context) async {
    var currentUserId = FirebaseService.getCurrentUser()!.uid;
    await FirebaseService.setEndPointForUsersChat(
      currentUserId,
      selectedUser.id,
    );

    // navigate to the chat screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          userToChatWithName: selectedUser.username,
        ),
      ),
    );
  }

  void handleSearchUser(String? text) {
    if (text != null) {
      setState(() {
        searchUserText = text.trim();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 5, bottom: 8, left: 10, right: 10),
          child: TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Search user',
            ),
            onChanged: handleSearchUser,
          ),
        ),
        Flexible(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseService.getUsers(searchUserText),
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
                    var user = UserData.fromDocument(userDocs[index]);
                    return !FirebaseService.isCurrentUser(user.id)
                        ? UserCard(
                            key: ValueKey(user.id),
                            user: user,
                            selectUserForChatting: selectUserToChatWith,
                          )
                        : SizedBox.shrink();
                  });
            },
          ),
        ),
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jabber_app/models/user_data.dart';

class UserCard extends StatelessWidget {
  final UserData user;
  final void Function(UserData user, BuildContext context)
      selectUserForChatting;
  const UserCard({
    Key? key,
    required this.user,
    required this.selectUserForChatting,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(user);
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Container(
          height: 50,
          width: 50,
          child: CircleAvatar(
            backgroundImage:
                user.imageUrl != null ? NetworkImage(user.imageUrl!) : null,
          ),
        ),
        title: Text(
          user.username,
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        onTap: () => selectUserForChatting(user, context),
      ),
    );
  }
}

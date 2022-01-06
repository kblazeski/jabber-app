import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final user;
  final void Function(dynamic user, BuildContext context) selectUserForChatting;
  const UserCard({
    Key? key,
    required this.user,
    required this.selectUserForChatting,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Container(
          height: 50,
          width: 50,
          child: CircleAvatar(
            backgroundImage: NetworkImage(user['image_url']),
          ),
        ),
        title: Text(
          user['username'],
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        onTap: () => selectUserForChatting(user, context),
      ),
    );
  }
}

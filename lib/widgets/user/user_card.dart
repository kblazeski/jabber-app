import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String username;
  final String userPicture;
  final String userId;
  final void Function(String selectedUserId,BuildContext context) selectUserForChatting;
  UserCard({
    Key? key,
    required this.userId,
    required this.username,
    required this.userPicture,
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
            backgroundImage: NetworkImage(userPicture),
          ),
        ),
        title: Text(
          username,
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        onTap: () => selectUserForChatting(userId,context),
      ),
    );
  }
}

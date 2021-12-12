import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String username;
  final String userImage;

  const MessageBubble({
    required this.message,
    required this.username,
    required this.isCurrentUser,
    required this.userImage,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                top: 4,
                right: 12,
                left: 12,
              ),
              child: Text(
                username,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment:
              isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isCurrentUser)
              Container(
                width: 50,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(userImage),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                color: isCurrentUser
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft:
                      !isCurrentUser ? Radius.circular(0) : Radius.circular(12),
                  bottomRight:
                      isCurrentUser ? Radius.circular(0) : Radius.circular(12),
                ),
              ),
              constraints: BoxConstraints(maxWidth: 240),
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 8,
              ),
              child: Text(
                message,
                style: TextStyle(
                  color: isCurrentUser ? Colors.white : Colors.black,
                ),
              ),
            ),
            if (isCurrentUser)
              Container(
                width: 50,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(userImage),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

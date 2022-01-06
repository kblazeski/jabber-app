import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jabber_app/models/message_data.dart';
import 'package:jabber_app/service/firebase_service.dart';

class MessageBubble extends StatelessWidget {
  final MessageData messageData;

  const MessageBubble({
    required this.messageData,
    Key? key,
  }) : super(key: key);

  bool isCurrentUser(MessageData messageData) {
    return FirebaseService.isCurrentUser(messageData.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isCurrentUser(messageData)
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: isCurrentUser(messageData)
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                top: 4,
                right: 12,
                left: 12,
              ),
              child: Text(
                messageData.username,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: isCurrentUser(messageData)
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            if (!isCurrentUser(messageData))
              Container(
                width: 50,
                child: CircleAvatar(
                  backgroundImage: messageData.userImage != null
                      ? NetworkImage(messageData.userImage!)
                      : null,
                ),
              ),
            Container(
              decoration: BoxDecoration(
                color: isCurrentUser(messageData)
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: !isCurrentUser(messageData)
                      ? Radius.circular(0)
                      : Radius.circular(12),
                  bottomRight: isCurrentUser(messageData)
                      ? Radius.circular(0)
                      : Radius.circular(12),
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
                messageData.text,
                style: TextStyle(
                  color:
                      isCurrentUser(messageData) ? Colors.white : Colors.black,
                ),
              ),
            ),
            if (isCurrentUser(messageData))
              Container(
                width: 50,
                child: CircleAvatar(
                  backgroundImage: messageData.userImage != null
                      ? NetworkImage(messageData.userImage!)
                      : null,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

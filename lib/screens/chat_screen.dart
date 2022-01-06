import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jabber_app/service/firebase_service.dart';
import 'package:jabber_app/widgets/chat/messages.dart';
import 'package:jabber_app/widgets/chat/new_message.dart';

class ChatScreen extends StatelessWidget {
  final String userToChatWithName;
  const ChatScreen({
    Key? key,
    required this.userToChatWithName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // extract Scaffold from the components
    return Scaffold(
      appBar: AppBar(
        title: Text(userToChatWithName),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}

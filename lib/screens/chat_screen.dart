import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jabber_app/widgets/chat/messages.dart';
import 'package:jabber_app/widgets/chat/new_message.dart';

class ChatScreen extends StatelessWidget {
  final CollectionReference<Map<String, dynamic>> messagesEndpoint;
  const ChatScreen({
    Key? key,
    required this.messagesEndpoint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // extract Scaffold from the components
    return Scaffold(
      appBar: AppBar(
        title: Text('Jabber'),
        actions: [
          DropdownButton(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              items: [
                DropdownMenuItem(
                  child: Container(
                    child: Row(children: [
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ]),
                  ),
                  value: 'logout',
                ),
              ],
              onChanged: (itemIdentifier) {
                if (itemIdentifier == 'logout') {
                  FirebaseAuth.instance.signOut();
                }
              })
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(messagesEndpoint: messagesEndpoint),
            ),
            NewMessage(messagesEndpoint: messagesEndpoint),
          ],
        ),
      ),
    );
  }
}

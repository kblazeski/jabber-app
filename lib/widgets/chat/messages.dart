import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jabber_app/widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  final CollectionReference<Map<String, dynamic>> messagesEndpoint;
  const Messages({
    Key? key,
    required this.messagesEndpoint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: messagesEndpoint
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = chatSnapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, index) => MessageBubble(
            key: ValueKey(chatDocs[index].id),
            message: chatDocs[index]['text'],
            username: chatDocs[index]['username'],
            userImage: chatDocs[index]['userImage'],
            isCurrentUser: chatDocs[index]['userId'] ==
                FirebaseAuth.instance.currentUser!.uid,
          ),
        );
      },
    );
  }
}

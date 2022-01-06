import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jabber_app/service/firebase_service.dart';
import 'package:jabber_app/widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseService.getChatMessages(),
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
            itemBuilder: (ctx, index) {
              var currentMessage = chatDocs[index];
              return MessageBubble(
                key: ValueKey(currentMessage.id),
                message: currentMessage['text'],
                username: currentMessage['username'],
                userImage: currentMessage['userImage'],
                isCurrentUser:
                    FirebaseService.isCurrentUser(currentMessage['userId']),
              );
            });
      },
    );
  }
}

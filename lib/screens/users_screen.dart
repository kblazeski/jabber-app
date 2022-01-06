import 'package:flutter/material.dart';
import 'package:jabber_app/service/firebase_service.dart';
import 'package:jabber_app/widgets/user/user_card.dart';
import 'package:jabber_app/widgets/user/users.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
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
                  FirebaseService.signOutUser();
                }
              })
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        child: Users(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:jabber_app/widgets/user/user_card.dart';
import 'package:jabber_app/widgets/user/users.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        child: Users(),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jabber_app/screens/auth_screen.dart';
import 'package:jabber_app/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jabber_app/static/Palette.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jabber',
      theme: ThemeData(
          primarySwatch: Palette.blue,
          backgroundColor: Palette.blue,
          errorColor: Colors.red,
          buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Palette.blue,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ))),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.hasData) {
            return ChatScreen();
          }
          return AuthScreen();
        },
      ),
    );
  }
}

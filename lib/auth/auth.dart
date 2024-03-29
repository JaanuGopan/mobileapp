import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smartgarden/auth/login_or_register.dart';
import 'package:smartgarden/pages/main_page.dart';


class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot) {
          //user logged in
          return snapshot.hasData ? MainPage() : LoginOrRegister();
        },
      ),
    );
  }
}

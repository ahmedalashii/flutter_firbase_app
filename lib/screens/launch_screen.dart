import 'dart:async';

import 'package:firebase_app/fb_controllers/fb_auth_controller.dart';
import 'package:firebase_app/fb_controllers/fb_notifications.dart';
import "package:flutter/material.dart";

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {

  late StreamSubscription stream;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      stream =
          FirebaseAuthController().checkUserStatus(({required bool loggedIn}) {
        String route = loggedIn ? "/notes_screen" : "/login_screen";
        Navigator.pushReplacementNamed(context, route);
      });
    });
  }

  @override
  void dispose() {
    stream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Firebase APP")),
    );
  }
}

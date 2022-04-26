import "package:flutter/material.dart";

import '../../fb_controllers/fb_auth_controller.dart';
import '../../fb_controllers/fb_notifications.dart';
import '../../utils/helpers.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with Helpers, FirebaseNotifications {
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;

  @override
  void initState() {
    super.initState();
    requestNotificationPermissions();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Login", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          const Text(
            "Welcome Back ...",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const Text(
            "Enter Email & Password",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _emailTextController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Email",
              prefixIcon: const Icon(Icons.email),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  width: 1,
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  width: 1,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _passwordTextController,
            obscureText: true,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: "Password",
              prefixIcon: const Icon(Icons.lock),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  width: 1,
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  width: 1,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async => performLogin(),
            child: const Text("Login"),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("Don't Have an account?"),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, "/register_screen"),
                child: const Text("Create Now!"),
              ),
            ],
          ),
          TextButton(
            onPressed: () =>
                Navigator.pushNamed(context, "/forget_password_screen"),
            child: const Text("Forget Password?"),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 10),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> performLogin() async {
    if (checkData()) {
      await login();
    }
  }

  bool checkData() {
    // Single Responsibility method
    if (_emailTextController.text.isNotEmpty &&
        _passwordTextController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(
        context: context, message: "Enter Required Data!", error: true);
    return false;
  }

  Future<void> login() async {
    bool status = await FirebaseAuthController().signIn(
        context: context,
        email: _emailTextController.text,
        password: _passwordTextController.text);
    if (status) {
      Navigator.pushReplacementNamed(context, "/notes_screen");
    }
  }
}

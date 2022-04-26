
import "package:flutter/material.dart";
import '../../utils/helpers.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen>
    with Helpers {
  late TextEditingController _emailTextController;

  @override
  void initState() {
    super.initState();
    _emailTextController = TextEditingController();
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Forget Password", style: TextStyle(color: Colors.black)),
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
            "Enter Email to send reset code",
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
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async => performForgetPassword(),
            child: const Text("Request Code"),
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
        ],
      ),
    );
  }

  Future<void> performForgetPassword() async {
    if (checkData()) {
      await forgetPassword();
    }
  }

  bool checkData() {
    // Single Responsibility method
    if (_emailTextController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(
        context: context, message: "Enter Required Email!", error: true);
    return false;
  }

  Future<void> forgetPassword() async {
    // bool status = await StudentApiController()
    //     .forgetPassword(context: context, email: _emailTextController.text);
    // if (status) {
    //   // Navigator.pushReplacementNamed(context, "/reset_password_screen");
    //   Navigator.pushReplacement(
    //     // we use this because we want to pass data to the other screen (reset password screen).
    //     context,
    //     MaterialPageRoute(
    //       builder: (BuildContext context) => ResetPasswordScreen(email: _emailTextController.text),
    //     ),
    //   );
    // }
  }
}

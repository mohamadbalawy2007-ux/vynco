import 'package:flutter/material.dart';
import 'package:project_1/My_Code/auth_code.dart';
import 'package:project_1/My_Pages/HomeUI.dart';
import 'package:project_1/My_Pages/My_Button/My_Button.dart';

class LoginUI extends StatelessWidget {
  final AuthCode _authCode = AuthCode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Enjoy Your Meetings !",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Image.asset("assets/Images/Meeting.png"),
          ),

          MyButton(
            txt: "Join Now Or Login",
            onClick: () async {
              await _authCode.SignInWithGoogle();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext) {
                    return HomeUI();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

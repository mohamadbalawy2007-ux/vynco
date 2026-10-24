import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_1/My_Code/auth_code.dart';
import 'package:project_1/My_Pages/HomeUI.dart';
import 'package:project_1/My_Pages/LoginUI.dart';
import 'package:project_1/My_Tools/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (defaultTargetPlatform == TargetPlatform.iOS) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyAsEHM8d7ee2n8odsmF-dfN_s0FnhDzHkc",
        appId: "1:561806827361:ios:f75a4346d50d6e12382f20",
        messagingSenderId: "561806827361",
        projectId: "my-app-d49d5",
        storageBucket: "my-app-d49d5.firebasestorage.app",
        iosBundleId: "com.mohamadb2007.project1",
        iosClientId: "561806827361-bflko3go5khhjre8q2t7airsv7e8guve.apps.googleusercontent.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: MyBackgroundColor,
      ),
      home: StreamBuilder(
        stream: AuthCode().authChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            return HomeUI();
          }

          return LoginUI();
        },
      ),
    );
  }
}

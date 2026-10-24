import 'package:flutter/material.dart';
import 'package:project_1/My_Code/auth_code.dart';
import 'package:project_1/My_Pages/LoginUI.dart';

class settingsUI extends StatefulWidget {
  const settingsUI({super.key});

  @override
  State<settingsUI> createState() => _settingsUIState();
}

class _settingsUIState extends State<settingsUI> {
  final AuthCode _authCode = AuthCode();

  @override
  Widget build(BuildContext context) {
    final String photo = _authCode.user?.photoURL ?? "";

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: photo.isNotEmpty ? NetworkImage(photo) : null,
              child: photo.isEmpty ? Icon(Icons.person, size: 50) : null,
            ),
            SizedBox(height: 15),
            Text(
              _authCode.user?.displayName ?? "",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(_authCode.user?.email ?? ""),
            Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 45),
              ),
              icon: Icon(Icons.logout),
              label: Text("Sign Out"),
              onPressed: () async {
                await _authCode.SignOut();
                if (!mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginUI()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
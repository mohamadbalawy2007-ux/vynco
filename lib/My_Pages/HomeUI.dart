import 'package:flutter/material.dart';
import 'package:project_1/My_Code/auth_code.dart';
import 'package:project_1/My_Pages/ContactsUI.dart';
import 'package:project_1/My_Pages/meetingsUI.dart';
import 'package:project_1/My_Pages/savedUI.dart';
import 'package:project_1/My_Pages/settingsUI.dart';

class HomeUI extends StatefulWidget {
  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  int PageIndex = 0;
  final myPages = [meetingsUI(), savedUI(), ContactsUI(), settingsUI()];
  final AuthCode _authCode = AuthCode();

  @override
  void initState() {
    _authCode.SaveUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 0, 127, 190),
        title: Text(
          "Vynco",
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: myPages[PageIndex],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            PageIndex = index;
          });
        },
        currentIndex: PageIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.blueAccent,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.comment_bank),
            label: "New Meet",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock_clock),
            label: "Meetings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Contacts",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
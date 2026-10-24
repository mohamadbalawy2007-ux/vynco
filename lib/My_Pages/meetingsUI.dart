import 'dart:math';

import 'package:flutter/material.dart';
import 'package:project_1/My_Code/jitsi_code.dart';
import 'package:project_1/My_Pages/JoinMeetUI.dart';
import 'package:project_1/My_Pages/My_Button/My_Icons.dart';

class meetingsUI extends StatefulWidget {
  @override
  State<meetingsUI> createState() => _meetingsUIState();
}

class _meetingsUIState extends State<meetingsUI> {
  final jitsiCode _jitsiCode = jitsiCode();

  CreateNewMeeting() {
    final random = Random.secure();
    String roomName = List.generate(
      10,
      (_) => random.nextInt(10),
    ).join();

    _jitsiCode.CreateMeet(
      roomName: roomName,
      isAudioMuted: true,
      isVideoMuted: true,
    );
  }

  JoinMeeting() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => JoinMeetingUI()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MyIcons(
            icon: Icons.videocam,
            txt: "New Meeting",
            onClick: () {
              CreateNewMeeting();
            },
          ),
          MyIcons(
            icon: Icons.add_box_rounded,
            txt: "Join Meeting",
            onClick: () {
              JoinMeeting();
            },
          ),
        ],
      ),
    );
  }
}
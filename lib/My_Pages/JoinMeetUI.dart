import 'package:flutter/material.dart';
import 'package:project_1/My_Code/auth_code.dart';
import 'package:project_1/My_Code/firestoredb_code.dart';
import 'package:project_1/My_Code/jitsi_code.dart';

class JoinMeetingUI extends StatefulWidget {
  @override
  State<JoinMeetingUI> createState() => _JoinMeetingUIState();
}

class _JoinMeetingUIState extends State<JoinMeetingUI> {
  late TextEditingController meetingID;
  late TextEditingController UserName;
  final AuthCode _authCode = AuthCode();
  final FirestoreDB _firestoreDB = FirestoreDB();
  final jitsiCode _jitsiCode = jitsiCode();

  @override
  void initState() {
    meetingID = TextEditingController(text: "123456");
    UserName = TextEditingController(text: _authCode.user!.displayName);
    super.initState();
  }

  JoinMeeting_btn() async {
    final String id = meetingID.text.trim();
    if (id.isEmpty) return;

    final bool MeetingExists = await _firestoreDB.checkMeetingfromDB(id);

    if (!MeetingExists) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("هذا الاجتماع غير موجود")),
      );
      return;
    }

    _jitsiCode.CreateMeet(
      roomName: id,
      isAudioMuted: true,
      isVideoMuted: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 0, 127, 190),
        title: Text("Join Meeting", style: TextStyle(fontSize: 25)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TextField(
            controller: meetingID,
            keyboardType: TextInputType.number,
            maxLines: 1,
            decoration: InputDecoration(
              fillColor: Colors.blueGrey,
              filled: true,
              border: InputBorder.none,
              hintText: "Meeting ID",
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),
          TextField(
            controller: UserName,
            keyboardType: TextInputType.name,
            maxLines: 1,
            decoration: InputDecoration(
              fillColor: Colors.blueGrey,
              filled: true,
              border: InputBorder.none,
              hintText: "User Name",
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),

          InkWell(
            child: Text(
              "Join",
              style: TextStyle(fontSize: 25, fontStyle: FontStyle.italic),
            ),
            onTap: () {
              JoinMeeting_btn();
            },
          ),
        ],
      ),
    );
  }
}
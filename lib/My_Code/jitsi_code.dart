import 'dart:math';

import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:project_1/My_Code/auth_code.dart';
import 'package:project_1/My_Code/firestoredb_code.dart';

class jitsiCode {
  final AuthCode _authCode = AuthCode();
  final FirestoreDB _firestoreDB = FirestoreDB();
  Future<void> CreateMeet({
    required String roomName,
    required bool isAudioMuted,
    required bool isVideoMuted,
  }) async {
    try {
      final currentUser = _authCode.user;

      if (currentUser == null) {
        print("لا يوجد مستخدم مسجل الدخول");
        return;
      }

      final jitsiMeet = JitsiMeet();

      final options = JitsiMeetConferenceOptions(
        serverURL: "https://meet.ffmuc.net",
        room: roomName,
        configOverrides: {
          "subject": "Meeting with ${_authCode.user!.displayName}",
          "startWithAudioMuted": isAudioMuted,
          "startWithVideoMuted": isVideoMuted,
        },
        userInfo: JitsiMeetUserInfo(
          displayName: currentUser.displayName ?? "",
          email: currentUser.email ?? "",
          avatar: currentUser.photoURL ?? "",
        ),
      );
      _firestoreDB.addMeetingtoDB(roomName);
      await jitsiMeet.join(
        options,
        JitsiMeetEventListener(
          conferenceTerminated: (url, error) {
            jitsiMeet.hangUp();
          },
          readyToClose: () {
            jitsiMeet.hangUp();
          },
        ),
      );
    } catch (error) {
      print("error: $error");
    }
  }

  Future<void> SendMeetingInvite(String ContactID) async {
    final random = Random.secure();
    String roomName = List.generate(10, (_) => random.nextInt(10)).join();

    await _firestoreDB.sendMessagetoDB(ContactID, roomName, type: "meeting");

    await CreateMeet(
      roomName: roomName,
      isAudioMuted: true,
      isVideoMuted: true,
    );
  }
}

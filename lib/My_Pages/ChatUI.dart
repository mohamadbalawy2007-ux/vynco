import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_1/My_Code/firestoredb_code.dart';
import 'package:project_1/My_Code/jitsi_code.dart';
import 'package:project_1/My_Tools/colors.dart';

class ChatUI extends StatefulWidget {
  final String ContactID;
  final String ContactName;
  final String ContactImage;
  const ChatUI({
    Key? key,
    required this.ContactID,
    required this.ContactName,
    required this.ContactImage,
  }) : super(key: key);

  @override
  State<ChatUI> createState() => _ChatUIState();
}

class _ChatUIState extends State<ChatUI> {
  final TextEditingController MessageText = TextEditingController();
  final FirestoreDB _firestoreDB = FirestoreDB();
  final jitsiCode _jitsiCode = jitsiCode();
  final String MyID = FirebaseAuth.instance.currentUser!.uid;
  final String MyImage = FirebaseAuth.instance.currentUser!.photoURL ?? "";

  SendMessage() {
    if (MessageText.text.trim().isEmpty) return;
    _firestoreDB.sendMessagetoDB(widget.ContactID, MessageText.text.trim());
    MessageText.clear();
  }

  JoinInvite(String roomName) {
    _jitsiCode.CreateMeet(
      roomName: roomName,
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
        title: Text(widget.ContactName, style: TextStyle(fontSize: 22)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {
              _jitsiCode.SendMeetingInvite(widget.ContactID);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _firestoreDB.getMessagesfromDB(widget.ContactID),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("خطأ: ${snapshot.error}"));
                }
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final data = docs[i].data();
                    final bool IsMe = data["Sender"] == MyID;
                    final String message = (data["Message"] ?? "").toString();
                    final String image = IsMe ? MyImage : widget.ContactImage;

                    final Widget Avatar = CircleAvatar(
                      radius: 16,
                      backgroundImage:
                          image.isNotEmpty ? NetworkImage(image) : null,
                      child: image.isEmpty ? Icon(Icons.person, size: 16) : null,
                    );

                    final Widget Bubble = Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: IsMe ? MyButtonColor : Colors.blueGrey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: data["Type"] == "meeting"
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Meeting Invitation",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text("ID: $message"),
                                ElevatedButton(
                                  onPressed: () {
                                    JoinInvite(message);
                                  },
                                  child: Text("Join"),
                                ),
                              ],
                            )
                          : Text(message),
                    );

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: IsMe
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: IsMe
                            ? [
                                Flexible(child: Bubble),
                                SizedBox(width: 6),
                                Avatar,
                              ]
                            : [
                                Avatar,
                                SizedBox(width: 6),
                                Flexible(child: Bubble),
                              ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: MessageText,
                    decoration: InputDecoration(
                      hintText: "Message",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    SendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
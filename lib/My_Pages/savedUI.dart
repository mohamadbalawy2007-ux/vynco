import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_1/My_Code/firestoredb_code.dart';

class savedUI extends StatelessWidget {
  savedUI({Key? key}) : super(key: key);

  final FirestoreDB _firestoreDB = FirestoreDB();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _firestoreDB.getMeetingsfromDB(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("خطأ: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return Center(
              child: Text(
                "Saved Meetings",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            );
          }
          return ListView.separated(
            itemCount: docs.length,
            separatorBuilder: (_, __) => Divider(height: 1),
            itemBuilder: (context, i) {
              final data = docs[i].data();
              final String meetingName = (data["MeetingName"] ?? "").toString();
              final Timestamp? ts = data["Meeting Date"] as Timestamp?;
              final String meetingDate =
                  ts == null ? "" : ts.toDate().toString().substring(0, 16);
              return ListTile(
                leading: Icon(Icons.videocam),
                title: Text(meetingName),
                subtitle: Text(meetingDate),
              );
            },
          );
        },
      ),
    );
  }
}
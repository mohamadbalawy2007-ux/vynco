import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_1/My_Code/firestoredb_code.dart';
import 'package:project_1/My_Code/jitsi_code.dart';
import 'package:project_1/My_Pages/ChatUI.dart';

class ContactsUI extends StatefulWidget {
  const ContactsUI({Key? key}) : super(key: key);

  @override
  State<ContactsUI> createState() => _ContactsUIState();
}

class _ContactsUIState extends State<ContactsUI> {
  final FirestoreDB _firestoreDB = FirestoreDB();
  final jitsiCode _jitsiCode = jitsiCode();

  AddContact() async {
    final TextEditingController EmailText = TextEditingController();
    final email = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Add Contact"),
        content: TextField(
          controller: EmailText,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(hintText: "Email"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, EmailText.text),
            child: Text("Add"),
          ),
        ],
      ),
    );

    if (email == null || email.trim().isEmpty) return;

    final result = await _firestoreDB.addContacttoDB(email);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AddContact();
        },
        child: Icon(Icons.person_add),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _firestoreDB.getContactsfromDB(),
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
                "Saved Contacts",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            );
          }
          return ListView.separated(
            itemCount: docs.length,
            separatorBuilder: (_, __) => Divider(height: 1),
            itemBuilder: (context, i) {
              final data = docs[i].data();
              final String name = (data["username"] ?? "").toString();
              final String email = (data["email"] ?? "").toString();
              final String image = (data["image"] ?? "").toString();
              final String uid = (data["uid"] ?? "").toString();
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: image.isNotEmpty ? NetworkImage(image) : null,
                  child: image.isEmpty
                      ? Text(name.isEmpty ? "?" : name[0].toUpperCase())
                      : null,
                ),
                title: Text(name),
                subtitle: Text(email),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatUI(
                        ContactID: uid,
                        ContactName: name,
                        ContactImage: image,
                      ),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: Icon(Icons.videocam),
                  onPressed: () {
                    _jitsiCode.SendMeetingInvite(uid);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
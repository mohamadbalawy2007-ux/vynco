import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDB {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void addMeetingtoDB(String meetingName) async {
    try {
      final meetingRef = _firebaseFirestore
          .collection("AllMeetings")
          .doc(meetingName);
      final meetingSnapshot = await meetingRef.get();
      if (!meetingSnapshot.exists) {
        await meetingRef.set({
          "MeetingName": meetingName,
          "Creator": _auth.currentUser!.uid,
          "Meeting Date": DateTime.now(),
        });
      }

      await _firebaseFirestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("Meetings")
          .add({"MeetingName": meetingName, "Meeting Date": DateTime.now()});
    } catch (e) {
      print(e);
    }
  }

  Future<bool> checkMeetingfromDB(String meetingName) async {
    try {
      final meetingSnapshot = await _firebaseFirestore
          .collection("AllMeetings")
          .doc(meetingName)
          .get();
      return meetingSnapshot.exists;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMeetingsfromDB() {
    return _firebaseFirestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .collection("Meetings")
        .orderBy("Meeting Date", descending: true)
        .snapshots();
  }

  Future<String> addContacttoDB(String contactEmail) async {
    try {
      final me = _auth.currentUser!;
      final result = await _firebaseFirestore
          .collection("users")
          .where("email", isEqualTo: contactEmail.trim().toLowerCase())
          .limit(1)
          .get();

      if (result.docs.isEmpty) {
        return "هذا الشخص ما عنده حساب بالتطبيق";
      }

      final contact = result.docs.first;
      final data = contact.data();

      if (contact.id == me.uid) {
        return "هذا ايميلك انت";
      }

      await _firebaseFirestore
          .collection("users")
          .doc(me.uid)
          .collection("Contacts")
          .doc(contact.id)
          .set({
        "username": data["username"],
        "email": data["email"],
        "image": data["image"],
        "uid": contact.id,
      });

      await _firebaseFirestore
          .collection("users")
          .doc(contact.id)
          .collection("Contacts")
          .doc(me.uid)
          .set({
        "username": me.displayName,
        "email": me.email?.toLowerCase(),
        "image": me.photoURL,
        "uid": me.uid,
      });

      return "تمت الاضافة";
    } catch (e) {
      print(e);
      return "صار خطأ";
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getContactsfromDB() {
    return _firebaseFirestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .collection("Contacts")
        .snapshots();
  }

  String getChatID(String ContactID) {
    final ids = [_auth.currentUser!.uid, ContactID];
    ids.sort();
    return ids.join("_");
  }

  Future<void> sendMessagetoDB(
    String ContactID,
    String message, {
    String type = "text",
  }) async {
    try {
      await _firebaseFirestore
          .collection("Chats")
          .doc(getChatID(ContactID))
          .collection("Messages")
          .add({
        "Message": message,
        "Sender": _auth.currentUser!.uid,
        "Type": type,
        "Message Date": DateTime.now(),
      });
    } catch (e) {
      print(e);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessagesfromDB(
    String ContactID,
  ) {
    return _firebaseFirestore
        .collection("Chats")
        .doc(getChatID(ContactID))
        .collection("Messages")
        .orderBy("Message Date", descending: true)
        .snapshots();
  }
}
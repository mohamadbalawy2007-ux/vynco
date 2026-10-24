import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthCode {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _Initialized = false;
  Stream<User?> get authChanges => _auth.authStateChanges();
  User? get user => _auth.currentUser;

  Future<User?> SignInWithGoogle() async {
    try {
      if (_auth.currentUser != null) {
        return _auth.currentUser;
      }

      final googleSignIn = GoogleSignIn.instance;

      if (!_Initialized) {
        await googleSignIn.initialize();
        _Initialized = true;
      }

      GoogleSignInAccount? googleUser =
          await googleSignIn.attemptLightweightAuthentication();

      googleUser ??= await googleSignIn.authenticate();

      final googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final doc = _firestore.collection("users").doc(user.uid);
        await doc.set({
          'username': user.displayName,
          'uid': user.uid,
          'image': user.photoURL,
          'email': user.email?.toLowerCase(),
        }, SetOptions(merge: true));
      }

      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> SaveUserData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;
      await _firestore.collection("users").doc(user.uid).set({
        'username': user.displayName,
        'uid': user.uid,
        'image': user.photoURL,
        'email': user.email?.toLowerCase(),
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  Future<void> SignOut() async {
    try {
      await GoogleSignIn.instance.signOut();
      await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  String uid;
  String email;

  AuthUser({this.uid, this.email});

  AuthUser.fromFirebaseUser(FirebaseUser user) {
    uid = user.uid;
    email = user.email;
  }
}

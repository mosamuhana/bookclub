import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../app.dart';
import '../models.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseMessaging _fcm = FirebaseMessaging();

  StreamController<AuthUser> _authStreamController;
  //Stream<AuthUser> _user$;
  AuthUser _user;

  AuthService() {
    _authStreamController = StreamController<AuthUser>.broadcast();
    _auth.onAuthStateChanged.listen((u) {
      if (u == null) {
        _user = null;
      } else {
        _user = AuthUser.fromFirebaseUser(u);
      }
      _authStreamController.add(_user);
    });
    /*
    _user$ = _auth.onAuthStateChanged.map((u) => (u != null) ? AuthUser.fromFirebaseUser(u) : null);
    _user$.listen((user) {
      _user = user;
    });
    */
  }

  bool get isAuth => _user != null;

  AuthUser get user => _user;

  Stream<AuthUser> get user$ => _authStreamController.stream; //_user$;
  //_auth.onAuthStateChanged.map((u) => (u != null) ? AuthUser.fromFirebaseUser(u) : null);

  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      print('[AuthService.signOut] error: $e');
    }
    return false;
  }

  Future<void> signUp({String email, String password, String fullName}) async {
    final authResult = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = User(
      uid: authResult.user.uid,
      email: authResult.user.email,
      fullName: fullName.trim(),
      accountCreated: Timestamp.now(),
      notifToken: await _fcm.getToken(),
    );

    final ok = await Locator.firestore.createUser(user);

    if (!ok) {
      throw Exception("Cannot save user ${user.email} to database");
    }
  }

  Future<void> signIn({String email, String password}) async {
    final res = await _auth
        .signInWithEmailAndPassword(
          email: email,
          password: password,
        )
        .timeout(
          Duration(seconds: 10),
          onTimeout: () => throw Exception('Connection timeout, Cannot reach host'),
        );
    showAuthResult(res);
    if (res?.user == null) {
      throw Exception('Invalid email/password');
    }
  }

  Future<void> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    final authResult = await _auth.signInWithCredential(credential);

    if (authResult.additionalUserInfo.isNewUser) {
      final user = User(
        uid: authResult.user.uid,
        email: authResult.user.email,
        fullName: authResult.user.displayName,
        accountCreated: Timestamp.now(),
        notifToken: await _fcm.getToken(),
      );

      final ok = await Locator.firestore.createUser(user);

      if (!ok) {
        throw Exception("Cannot save user ${user.email} to database");
      }
    }
  }

  showAuthResult(AuthResult res) {
    if (res?.user == null) {
      print('user = null');
      return;
    }
    final userInfo = res.additionalUserInfo;
    final user = res.user;
    print('additionalUserInfo.isNewUser: ${userInfo.isNewUser}');
    print('additionalUserInfo.providerId: ${userInfo.providerId}');
    print('additionalUserInfo.username: ${userInfo.username}');
    print('additionalUserInfo.isNewUser: ${jsonEncode(userInfo.profile)}');

    print('user.displayName: ${user.displayName}');
    print('user.email: ${user.email}');
    print('user.isEmailVerified: ${user.isEmailVerified}');
    print('user.phoneNumber: ${user.phoneNumber}');
    print('user.photoUrl: ${user.photoUrl}');
    print('user.providerId: ${user.providerId}');
    print('user.uid: ${user.uid}');
    print('user.metadata.creationTime: ${user.metadata.creationTime}');
    print('user.metadata.lastSignInTime: ${user.metadata.lastSignInTime}');
    //print('user.providerData: ${user.providerData}');
  }
}

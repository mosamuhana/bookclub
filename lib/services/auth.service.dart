import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../models.dart';
import '../app.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
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

  Future<bool> signIn({String email, String password}) async {
    try {
      final res = await _auth.signInWithEmailAndPassword(email: email, password: password).timeout(
            Duration(seconds: 10),
            onTimeout: () => throw Exception('Connection timeout, Cannot reach host'),
          );
      if (res.user != null) {
        showAuthResult(res);
      }
      return res.user != null;
    } catch (e) {
      final msg = e.message ?? e.toString();
      print('[AuthService.signIn] error: (${e.runtimeType}) $msg');
      rethrow;
    }
  }

  Future<bool> signUp({String email, String password, String fullName}) async {
    try {
      final res = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (res.user != null) {
        showAuthResult(res);
        return true;
      }
    } catch (e) {
      print('[AuthService.signUp] error: $e');
    }
    return false;
  }

  showAuthResult(AuthResult res) {
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

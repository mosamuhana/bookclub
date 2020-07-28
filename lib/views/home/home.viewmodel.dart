import 'dart:async';

import 'package:stacked/stacked.dart';

import '../../app.dart';
import '../../models.dart';

class HomeViewModel extends BaseViewModel {
  AuthUser get user => Locator.auth.user;

  Future<void> signOut() async {
    try {
      await Locator.auth.signOut();
      await Locator.navigation.replaceWith(Routes.login);
    } catch (e) {
      Locator.snackbar.showSnackbar(
        message: 'Logout error',
        title: 'Error',
        duration: Duration(seconds: 3),
      );
    }
  }
}

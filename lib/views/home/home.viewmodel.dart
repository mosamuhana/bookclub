import 'package:stacked/stacked.dart';

import '../../app.dart';

class HomeViewModel extends BaseViewModel {
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

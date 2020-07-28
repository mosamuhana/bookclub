import 'package:reactive_forms/reactive_forms.dart';
import 'package:stacked/stacked.dart';

import '../../app.dart';

class LoginViewModel extends BaseViewModel {
  final form = FormGroup({
    'email': FormControl(
      validators: [
        Validators.required,
        Validators.email,
      ],
    ),
    'password': FormControl(validators: [
      Validators.required,
      Validators.minLength(6),
    ]),
  });

  FormControl get emailControl => form.control('email');
  FormControl get passwordControl => form.control('password');

  Future<void> submit() async {
    String email = emailControl.value;
    String password = passwordControl.value;
    setBusy(true);
    String msg;
    try {
      //await Future.delayed(Duration(seconds: 10));
      final ok = await Locator.auth.signIn(email: email, password: password);
      if (ok) {
        await Locator.navigation.replaceWith(Routes.home);
        return;
      }
      msg = 'Invalid email/password';
    } catch (e) {
      msg = e.message ?? e.toString();
    } finally {
      setBusy(false);
    }
    Locator.snackbar
        .showCustomSnackBar(message: msg, title: 'Error', duration: Duration(seconds: 2));
  }

  void onEmailSubmitted() => passwordControl.focus();

  void onPasswordSubmitted() {
    if (form.valid && !isBusy) {
      submit();
    }
  }

  void navigateToSignup() {
    Locator.navigation.replaceWith(Routes.signup);
  }

  @override
  void dispose() {
    form.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:stacked/stacked.dart';

import '../../app.dart';

const F_EMAIL = 'email';
const F_PASSWORD = 'password';

class LoginViewModel extends BaseViewModel {
  final form = FormGroup({
    F_EMAIL: FormControl(
      validators: [
        Validators.required,
        Validators.email,
      ],
    ),
    F_PASSWORD: FormControl(
      validators: [
        Validators.required,
        Validators.minLength(6),
      ],
    ),
  });

  FormControl get emailControl => form.control(F_EMAIL);
  FormControl get passwordControl => form.control(F_PASSWORD);

  Future<void> _signIn([bool withGoogle = false]) async {
    setBusy(true);
    try {
      if (withGoogle) {
        await Locator.auth.signInWithGoogle();
      } else {
        await Locator.auth.signIn(email: emailControl.value, password: passwordControl.value);
      }
      await Locator.navigation.replaceWith(Routes.home);
      return;
    } catch (e) {
      String message = e.message ?? e.toString();
      Locator.snackbar.showSnackbar(
        message: message,
        title: 'Error',
        duration: Duration(seconds: 3),
      );
    } finally {
      setBusy(false);
    }
  }

  bool get canSubmit => form.valid && !isBusy;

  void _submit() => _submit();
  void _submitWithGoogle() => _signIn(true);

  Function get submit => !canSubmit ? null : _submit;
  Function get submitWithGoogle => isBusy ? null : _submitWithGoogle;

  void onEmailSubmitted() => passwordControl.focus();

  void onPasswordSubmitted() {
    if (canSubmit) {
      _submit();
    }
  }

  void _navigateToSignup() => Locator.navigation.replaceWith(Routes.signup);

  Function get navigateToSignup => isBusy ? null : _navigateToSignup;

  @override
  void dispose() {
    form.dispose();
    super.dispose();
  }
}

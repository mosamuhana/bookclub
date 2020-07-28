import 'package:reactive_forms/reactive_forms.dart';
import 'package:stacked/stacked.dart';

import '../../app.dart';

const FULL_NAME = 'fullName';
const EMAIL = 'email';
const PASSWORD = 'password';
const PASSWORD_CONFIRM = 'passwordConfirm';

class SignupViewModel extends BaseViewModel {
  final form = FormGroup(
    {
      FULL_NAME: FormControl(
        validators: [
          Validators.required,
          Validators.minLength(3),
        ],
      ),
      EMAIL: FormControl(
        validators: [
          Validators.required,
          Validators.email,
        ],
      ),
      PASSWORD: FormControl(
        validators: [
          Validators.required,
          Validators.minLength(6),
        ],
      ),
      PASSWORD_CONFIRM: FormControl(
        validators: [
          Validators.required,
          Validators.minLength(6),
        ],
      ),
    },
    validators: [
      Validators.mustMatch(PASSWORD, PASSWORD_CONFIRM),
    ],
  );

  FormControl get fullNameControl => form.control(FULL_NAME);
  FormControl get emailControl => form.control(EMAIL);
  FormControl get passwordControl => form.control(PASSWORD);
  FormControl get passwordConfirmControl => form.control(PASSWORD_CONFIRM);

  Future<void> submit() async {
    String fullName = fullNameControl.value;
    String email = emailControl.value;
    String password = passwordControl.value;
    String msg;
    setBusy(true);
    try {
      //await Future.delayed(Duration(seconds: 10));
      final ok = await Locator.auth.signUp(email: email, password: password, fullName: fullName);
      if (ok) {
        await Locator.snackbar
            .showCustomSnackBar(message: 'Successfully created.', duration: Duration(seconds: 3));
        await Locator.navigation.replaceWith(Routes.login);
        return;
      }
      msg = 'Unknown Error';
    } catch (e) {
      msg = e.message ?? e.toString();
    } finally {
      setBusy(false);
    }
    Locator.snackbar
        .showCustomSnackBar(message: msg, title: 'Error', duration: Duration(seconds: 2));
  }

  void onFulNameSubmitted() => emailControl.focus();

  void onEmailSubmitted() => passwordControl.focus();

  void onPasswordSubmitted() => passwordConfirmControl.focus();

  void onPasswordConfirmSubmitted() {
    if (form.valid && !isBusy) {
      submit();
    }
  }

  void navigateToLogin() {
    Locator.navigation.replaceWith(Routes.login);
  }

  @override
  void dispose() {
    form.dispose();
    super.dispose();
  }
}

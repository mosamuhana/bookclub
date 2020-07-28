import 'package:reactive_forms/reactive_forms.dart';
import 'package:stacked/stacked.dart';

import '../../app.dart';

const F_FULL_NAME = 'fullName';
const F_EMAIL = 'email';
const F_PASSWORD = 'password';
const F_PASSWORD_CONFIRM = 'passwordConfirm';

class SignupViewModel extends BaseViewModel {
  final form = FormGroup(
    {
      F_FULL_NAME: FormControl<String>(
        validators: [
          Validators.required,
          Validators.minLength(3),
        ],
      ),
      F_EMAIL: FormControl<String>(
        validators: [
          Validators.required,
          Validators.email,
        ],
      ),
      F_PASSWORD: FormControl<String>(
        validators: [
          Validators.required,
          Validators.minLength(6),
        ],
      ),
      F_PASSWORD_CONFIRM: FormControl<String>(
        validators: [
          Validators.required,
          Validators.minLength(6),
        ],
      ),
    },
    validators: [
      Validators.mustMatch(F_PASSWORD, F_PASSWORD_CONFIRM),
    ],
  );

  FormControl<String> get fullNameControl => form.control(F_FULL_NAME);
  FormControl<String> get emailControl => form.control(F_EMAIL);
  FormControl<String> get passwordControl => form.control(F_PASSWORD);
  FormControl<String> get passwordConfirmControl => form.control(F_PASSWORD_CONFIRM);

  bool get canSubmit => form.valid && !isBusy;

  Future<void> _submit() async {
    setBusy(true);
    try {
      await Locator.auth.signUp(
        email: emailControl.value.trim(),
        password: passwordControl.value.trim(),
        fullName: fullNameControl.value.trim(),
      );
      Locator.snackbar.showSnackbar(
        message: 'Successfully created.',
        duration: Duration(seconds: 3),
      );
      Locator.navigation.replaceWith(Routes.login);
      return;
    } catch (e) {
      String msg = e.message ?? e.toString();
      Locator.snackbar.showSnackbar(message: msg, title: 'Error', duration: Duration(seconds: 2));
    } finally {
      setBusy(false);
    }
  }

  Function get submit => !canSubmit ? null : _submit;

  void onFulNameSubmitted() => emailControl.focus();

  void onEmailSubmitted() => passwordControl.focus();

  void onPasswordSubmitted() => passwordConfirmControl.focus();

  void onPasswordConfirmSubmitted() {
    if (form.valid && !isBusy) {
      submit();
    }
  }

  void _navigateToLogin() => Locator.navigation.replaceWith(Routes.login);

  Function get navigateToLogin => isBusy ? null : _navigateToLogin;

  @override
  void dispose() {
    form.dispose();
    super.dispose();
  }
}

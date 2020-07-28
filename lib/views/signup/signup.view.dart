import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:stacked/stacked.dart';

import '../../widgets.dart';
import 'signup.viewmodel.dart';

final _buttonStyle = TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold);
final _verticalSpacer = SizedBox(height: 10);

class SignupView extends ViewModelBuilderWidget<SignupViewModel> {
  SignupView({Key key}) : super(key: key);

  @override
  SignupViewModel viewModelBuilder(BuildContext context) => SignupViewModel();

  @override
  bool get createNewModelOnInsert => true;

  @override
  Widget builder(BuildContext context, SignupViewModel model, Widget child) {
    return WillPopScope(
      onWillPop: () async => !model.isBusy,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildForm(context, model),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, SignupViewModel model) {
    final t = Theme.of(context);
    return ShadowContainer(
      child: ReactiveForm(
        formGroup: model.form,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
              child: Text(
                'Sign Up',
                style: TextStyle(
                    color: t.secondaryHeaderColor, fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            ReactiveTextField(
              formControlName: F_FULL_NAME,
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
              textInputAction: TextInputAction.next,
              onSubmitted: model.onFulNameSubmitted,
            ),
            _verticalSpacer,
            ReactiveTextField(
              formControlName: F_EMAIL,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.alternate_email),
              ),
              validationMessages: {
                ValidationMessage.required: 'The email must not be empty',
                ValidationMessage.email: 'The email value must be a valid email',
              },
              textInputAction: TextInputAction.next,
              onSubmitted: model.onEmailSubmitted, //() => model.passwordControl.focus(),
            ),
            _verticalSpacer,
            ReactiveTextField(
              formControlName: F_PASSWORD,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
              validationMessages: {
                ValidationMessage.required: 'The password must not be empty',
                ValidationMessage.minLength: 'The password must be at least 6 characters',
              },
              textInputAction: TextInputAction.next,
              onSubmitted: model.onPasswordSubmitted, // onSubmitted: () {},
            ),
            _verticalSpacer,
            ReactiveTextField(
              formControlName: F_PASSWORD_CONFIRM,
              decoration: InputDecoration(
                labelText: 'Password Confirm',
                prefixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
              validationMessages: {
                ValidationMessage.required: 'The password must not be empty',
                ValidationMessage.minLength: 'The password must be at least 6 characters',
                ValidationMessage.mustMatch: 'The password does not match',
              },
              textInputAction: TextInputAction.next,
              onSubmitted: model.onPasswordConfirmSubmitted, // onSubmitted: () {},
            ),
            _verticalSpacer,
            ReactiveFormConsumer(
              builder: (context, form, child) {
                return RaisedButton(
                  child: Text('Register', style: _buttonStyle),
                  onPressed: model.submit,
                );
              },
            ),
            FlatButton(
              onPressed: model.navigateToLogin,
              child: Text("You have an account? login here"),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }
}

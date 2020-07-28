import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:stacked/stacked.dart';

import '../../r.dart';
import '../../widgets.dart';
import 'login.viewmodel.dart';

final _buttonStyle = TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold);

final _box10 = SizedBox(height: 10);

final _logo = Container(
  height: 150,
  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
  child: Image.asset(Images.logo),
);

class LoginView extends ViewModelBuilderWidget<LoginViewModel> {
  LoginView({Key key}) : super(key: key);

  @override
  LoginViewModel viewModelBuilder(BuildContext context) => LoginViewModel();

  @override
  bool get createNewModelOnInsert => true;

  @override
  Widget builder(BuildContext context, LoginViewModel model, Widget child) {
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
                  _logo,
                  _box10,
                  _buildForm(context, model),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, LoginViewModel model) {
    final t = Theme.of(context);
    return ShadowContainer(
      child: ReactiveForm(
        formGroup: model.form,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
              child: Text(
                'Log In',
                style: TextStyle(
                    color: t.secondaryHeaderColor, fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            ReactiveTextField(
              formControlName: 'email',
              decoration: InputDecoration(
                labelText: 'Email',
                suffixIcon: ReactiveStatusListenableBuilder(
                  formControlName: 'email',
                  builder: (context, control, child) {
                    return control.pending
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Container(width: 0);
                  },
                ),
              ),
              validationMessages: {
                ValidationMessage.required: 'The email must not be empty',
                ValidationMessage.email: 'The email value must be a valid email',
              },
              textInputAction: TextInputAction.next,
              onSubmitted: model.onEmailSubmitted, //() => model.passwordControl.focus(),
            ),
            SizedBox(height: 20),
            ReactiveTextField(
              formControlName: 'password',
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
              validationMessages: {
                ValidationMessage.required: 'The password must not be empty',
                ValidationMessage.minLength: 'The password must be at least 6 characters',
              },
              textInputAction: TextInputAction.next,
              onSubmitted: model.onPasswordSubmitted, // onSubmitted: () {},
            ),
            SizedBox(height: 20),
            ReactiveFormConsumer(
              builder: (context, form, child) {
                return RaisedButton(
                  child: Text('Login', style: _buttonStyle),
                  onPressed: (form.valid && !model.isBusy) ? model.submit : null,
                );
              },
            ),
            FlatButton(
              onPressed: model.isBusy ? null : model.navigateToSignup,
              child: Text("Don't have an account? sign up here"),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:stacked/stacked.dart';

import '../../r.dart';
import '../../widgets.dart';
import 'login.viewmodel.dart';

final _buttonStyle = TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold);

final _spacerBox = SizedBox(height: 10);

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
                  _spacerBox,
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
            _spacerBox,
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
            _spacerBox,
            RaisedButton(
              child: Text('Login', style: _buttonStyle),
              onPressed: model.submit,
            ),
            FlatButton(
              onPressed: model.navigateToSignup,
              child: Text("Don't have an account? sign up here"),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            SizedBox(height: 20),
            _buildGoogleButton(context, model),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleButton(BuildContext context, LoginViewModel model) {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: model.submitWithGoogle,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      highlightElevation: 10,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage(Images.googleLogo), height: 25.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            )
          ],
        ),
      ),
    );
  }
}

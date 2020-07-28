import 'package:flutter/material.dart';

import '../../views.dart';
import '../../widgets.dart';
import '../../app.dart';

part '_signup_form.dart';

class SignupView extends StatelessWidget {
  const SignupView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);
    return Scaffold(
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  if (canPop) BackButton(),
                  SizedBox(height: 10),
                  _SignupForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

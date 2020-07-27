import 'package:flutter/material.dart';

import '../../views.dart';
import '../../widgets.dart';
import '../../r.dart';

part '_login_form.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(10),
              children: [
                if (canPop) BackButton(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: Image.asset(Images.logo),
                ),
                SizedBox(height: 10),
                _LoginForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

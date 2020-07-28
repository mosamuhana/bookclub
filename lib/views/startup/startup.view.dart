import 'package:flutter/material.dart';

import '../../app.dart';

class StartupView extends StatefulWidget {
  const StartupView({Key key}) : super(key: key);

  @override
  _StartupViewState createState() => _StartupViewState();
}

class _StartupViewState extends State<StartupView> {
  @override
  void initState() {
    super.initState();
    Locator.auth.user$.listen((user) {
      if (user == null) {
        print('user = null');
        Locator.navigation.replaceWith(Routes.login);
      } else {
        print('user.email = ${user.email}');
        Locator.navigation.replaceWith(Routes.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(backgroundColor: Colors.blue),
            SizedBox(height: 20),
            Text('Loading ...'),
          ],
        ),
      ),
    );
  }
}

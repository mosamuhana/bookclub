import 'package:flutter/material.dart';

import 'locator.dart';
import 'router.dart';
import 'utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Locator.setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Club',
      theme: AppTheme.build(),
      initialRoute: Router.routes.login,
      onGenerateRoute: Router.instance.onGenerateRoute,
      navigatorKey: Locator.navigation.navigatorKey,
    );
  }
}

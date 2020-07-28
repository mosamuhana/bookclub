import 'package:flutter/material.dart';

import 'app.dart';
import 'utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Locator.setup();

  runApp(Application());
}

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Club',
      theme: AppTheme.build(),
      initialRoute: Routes.signup,
      onGenerateRoute: Router().onGenerateRoute,
      navigatorKey: Locator.navigation.navigatorKey,
    );
  }
}

import 'package:auto_route/auto_route.dart';

import '../locator.dart';

class AuthGuard extends RouteGuard {
  @override
  Future<bool> canNavigate(
    ExtendedNavigatorState navigator,
    String routeName,
    Object arguments,
  ) async {
    //final user = await Locator.auth.user$.last;
    //return user != null;
    return Locator.auth.isAuth;
  }
}

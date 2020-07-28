import 'package:auto_route/auto_route.dart';

import '../locator.dart';

class NoAuthGuard extends RouteGuard {
  @override
  Future<bool> canNavigate(
    ExtendedNavigatorState navigator,
    String routeName,
    Object arguments,
  ) async {
    return !Locator.auth.isAuth;
  }
}

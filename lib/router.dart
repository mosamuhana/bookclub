import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'services/auth.guard.dart';
import 'services/no_auth.guard.dart';
import 'views.dart';

abstract class Routes {
  static const String startup = '/startup';
  static const String initial = startup;
  static const String home = '/home';
  static const String login = '/login';
  static const String signup = '/signup';
  //Set<String> get all => {LOGIN_ROUTE, SIGNUP_ROUTE};
}

Route<dynamic> _onStartup(RouteData data) {
  var args = data.getArgs<StartupViewArgs>(orElse: () => StartupViewArgs());
  return MaterialPageRoute<dynamic>(
    builder: (context) => StartupView(key: args.key),
    settings: data,
  );
}

Route<dynamic> _onHome(RouteData data) {
  var args = data.getArgs<HomeViewArgs>(orElse: () => HomeViewArgs());
  return MaterialPageRoute<dynamic>(
    builder: (context) => HomeView(key: args.key),
    settings: data,
  );
}

Route<dynamic> _onLogin(RouteData data) {
  var args = data.getArgs<LoginViewArgs>(orElse: () => LoginViewArgs());
  return MaterialPageRoute<dynamic>(
    builder: (context) => LoginView(
      key: args.key,
      //title: args.title,
      //userId: data.pathParams['id'].intValue,
    ),
    settings: data,
  );
}

Route<dynamic> _onSignup(RouteData data) {
  var args = data.getArgs<SignupViewArgs>(orElse: () => SignupViewArgs());
  return MaterialPageRoute<dynamic>(
    builder: (context) => SignupView(key: args.key),
    settings: data,
  );
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => [
        RouteDef(Routes.startup, page: StartupView),
        RouteDef(Routes.home, page: HomeView, guards: [AuthGuard]),
        RouteDef(Routes.login, page: LoginView, guards: [NoAuthGuard]),
        RouteDef(Routes.signup, page: SignupView, guards: [NoAuthGuard]),
      ];

  @override
  Map<Type, AutoRouteFactory> get pagesMap => {
        StartupView: _onStartup,
        HomeView: _onHome,
        LoginView: _onLogin,
        SignupView: _onSignup,
      };
}

class StartupViewArgs {
  final Key key;
  StartupViewArgs({this.key});
}

class HomeViewArgs {
  final Key key;
  HomeViewArgs({this.key});
}

class LoginViewArgs {
  final Key key;
  LoginViewArgs({this.key});
}

class SignupViewArgs {
  final Key key;
  SignupViewArgs({this.key});
}

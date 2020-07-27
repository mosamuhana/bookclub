import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'views.dart';

const String LOGIN_ROUTE = '/login';
const String SIGNUP_ROUTE = '/signup';

class _Routes {
  final String login = LOGIN_ROUTE;
  final String signup = SIGNUP_ROUTE;
  //Set<String> get all => {LOGIN_ROUTE, SIGNUP_ROUTE};
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

class _Router extends RouterBase {
  @override
  List<RouteDef> get routes => [
        RouteDef(LOGIN_ROUTE, page: LoginView),
        RouteDef(SIGNUP_ROUTE, page: SignupView),
      ];

  @override
  Map<Type, AutoRouteFactory> get pagesMap => {
        LoginView: _onLogin,
        SignupView: _onSignup,
      };
}

class Router {
  static _Router _instance;
  static _Router get instance => _instance ??= _Router();
  static _Routes get routes => _Routes();
}

/// ************************************************************************
/// Navigation helper methods extension
/// *************************************************************************

extension ExtendedNavigatorStateExtension on ExtendedNavigatorState {
  Future<T> pushLogin<T>({Key key}) => push<T>(LOGIN_ROUTE, arguments: LoginViewArgs(key: key));

  Future<T> pushSignup<T>({Key key}) => push<T>(SIGNUP_ROUTE, arguments: SignupViewArgs(key: key));
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

class LoginViewArgs {
  final Key key;
  LoginViewArgs({this.key});
}

class SignupViewArgs {
  final Key key;
  SignupViewArgs({this.key});
}

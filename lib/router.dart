import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'views.dart';

const String LOGIN_ROUTE = '/login';
const String SIGNUP_ROUTE = '/signup';

class _Routes {
  final String login = '/login';
  final String signup = '/signup';
  Set<String> get all => {login, signup};
}

final _routes = <RouteDef>[
  RouteDef(LOGIN_ROUTE, page: LoginView),
  RouteDef(SIGNUP_ROUTE, page: SignupView),
];

final _pagesMap = <Type, AutoRouteFactory>{
  LoginView: (data) {
    var args = data.getArgs<LoginViewArguments>(orElse: () => LoginViewArguments());
    return MaterialPageRoute<dynamic>(
      builder: (context) => LoginView(
        key: args.key,
        //title: args.title,
        //userId: data.pathParams['id'].intValue,
      ),
      settings: data,
    );
  },
  SignupView: (data) {
    var args = data.getArgs<SignupViewArguments>(orElse: () => SignupViewArguments());
    return MaterialPageRoute<dynamic>(
      builder: (context) => SignupView(key: args.key),
      settings: data,
    );
  },
};

class _Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;

  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
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
  Future<T> pushLogin<T>({Key key}) => push<T>(
        LOGIN_ROUTE,
        arguments: LoginViewArguments(key: key),
      );

  Future<T> pushSignup<T>({Key key}) => push<T>(
        SIGNUP_ROUTE,
        arguments: SignupViewArguments(key: key),
      );
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

class LoginViewArguments {
  final Key key;
  LoginViewArguments({this.key});
}

class SignupViewArguments {
  final Key key;
  SignupViewArguments({this.key});
}

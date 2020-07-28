import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:get/get.dart';

import 'services/auth.service.dart';
import 'services/firestore.service.dart';

Future<void> _setup(GetIt g) async {
  g.registerLazySingleton<DialogService>(() => DialogService());
  g.registerLazySingleton<NavigationService>(() => NavigationService());
  g.registerLazySingleton<SnackbarService>(() => SnackbarService());
  g.registerLazySingleton<AuthService>(() => AuthService());
  g.registerLazySingleton<FirestoreService>(() => FirestoreService());
}

class Locator {
  static bool _initialized = false;
  static GetIt _instance = GetIt.instance;

  static Future<void> setup() async {
    if (_initialized) return;
    await _setup(_instance);

    snackbar.registerSnackbarConfig(SnackbarConfig(
      snackPosition: SnackPosition.BOTTOM,
      snackStyle: SnackStyle.FLOATING,
    ));

    _initialized = true;
  }

  static T resolve<T>() => _instance<T>();

  // -------------------------------------------

  static SnackbarService _snackbarService;
  static DialogService _dialogService;
  static NavigationService _navigationService;
  static AuthService _authService;
  static FirestoreService _firestoreService;

  static SnackbarService get snackbar => _snackbarService ??= _instance<SnackbarService>();
  static DialogService get dialog => _dialogService ??= _instance<DialogService>();
  static NavigationService get navigation => _navigationService ??= _instance<NavigationService>();

  static AuthService get auth => _authService ??= _instance<AuthService>();
  static FirestoreService get firestore => _firestoreService ??= _instance<FirestoreService>();
}

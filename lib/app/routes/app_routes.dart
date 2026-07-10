part of 'app_pages.dart';


abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const LOGIN = _Paths.LOGIN;
  static const SETTINGS = _Paths.SETTINGS;
  static const COMPANY_SELECTION = _Paths.COMPANY_SELECTION; 
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const LOGIN = '/login';
  static const SETTINGS = '/settings';
   static const COMPANY_SELECTION = '/company-selection';
}

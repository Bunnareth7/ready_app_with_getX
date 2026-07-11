import 'package:get/get.dart';
import 'package:learn_getx2/app/modules/company_selection/bindings/company_selection_binding.dart';
import 'package:learn_getx2/app/modules/company_selection/views/company_selection_view.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  //static const INITIAL = Routes.HOME;
  static const INITIAL = Routes.LOGIN;
  //static const INITIAL = Routes.COMPANY_SELECTION;
  static final routes = [
     GetPage(
      name: _Paths.COMPANY_SELECTION,
      page: () => const CompanySelectionView(),
      binding: CompanySelectionBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
  ];
}

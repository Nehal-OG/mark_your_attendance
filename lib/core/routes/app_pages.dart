import 'package:get/get.dart';
import 'package:mark_your_attendance/core/routes/app_routes.dart';
import 'package:mark_your_attendance/features/auth/presentation/bindings/splash_binding.dart';
import 'package:mark_your_attendance/features/auth/presentation/views/splash_view.dart';
import 'package:mark_your_attendance/features/auth/presentation/views/login_view.dart';
import 'package:mark_your_attendance/features/navigation/presentation/bindings/navigation_binding.dart';
import 'package:mark_your_attendance/features/navigation/presentation/views/main_navigation.dart';
import 'package:mark_your_attendance/features/auth/presentation/bindings/registration_binding.dart';
import 'package:mark_your_attendance/features/auth/presentation/views/registration_view.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginView(),
      // binding: LoginBinding(), // TODO: Add login binding
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => RegistrationView(),
      binding: RegistrationBinding(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const MainNavigation(),
      binding: NavigationBinding(),
    ),
    // Add other routes here
  ];
} 
import 'package:get/get.dart';
import 'package:mark_your_attendance/core/routes/app_routes.dart';
import 'package:mark_your_attendance/features/auth/presentation/bindings/splash_binding.dart';
import 'package:mark_your_attendance/features/auth/presentation/views/splash_view.dart';
import 'package:mark_your_attendance/features/auth/presentation/views/login_view.dart';

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
    // Add other routes here
  ];
} 
import 'package:get/get.dart';
import 'package:mark_your_attendance/core/routes/app_routes.dart';
import 'package:mark_your_attendance/features/auth/presentation/bindings/splash_binding.dart';
import 'package:mark_your_attendance/features/auth/presentation/views/splash_view.dart';
import 'package:mark_your_attendance/features/auth/presentation/views/login_view.dart';
import 'package:mark_your_attendance/features/navigation/presentation/bindings/navigation_binding.dart';
import 'package:mark_your_attendance/features/navigation/presentation/views/main_navigation.dart';
import 'package:mark_your_attendance/features/auth/presentation/bindings/registration_binding.dart';
import 'package:mark_your_attendance/features/auth/presentation/views/registration_view.dart';
import 'package:mark_your_attendance/features/auth/presentation/bindings/login_binding.dart';
import 'package:mark_your_attendance/features/auth/presentation/bindings/password_reset_binding.dart';
import 'package:mark_your_attendance/features/auth/presentation/views/password_reset_view.dart';
import 'package:mark_your_attendance/features/home/presentation/bindings/home_binding.dart';
import 'package:mark_your_attendance/features/home/presentation/views/home_view.dart';
import 'package:mark_your_attendance/features/calendar/presentation/bindings/calendar_binding.dart';
import 'package:mark_your_attendance/features/calendar/presentation/views/calendar_view.dart';

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
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => RegistrationView(),
      binding: RegistrationBinding(),
    ),
    GetPage(
      name: AppRoutes.FORGOT_PASSWORD,
      page: () => PasswordResetView(),
      binding: PasswordResetBinding(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.MAIN,
      page: () => const MainNavigation(),
      binding: NavigationBinding(),
    ),
    GetPage(
      name: AppRoutes.CALENDAR,
      page: () => const CalendarView(),
      binding: CalendarBinding(),
    ),
    // Add other routes here
  ];
} 
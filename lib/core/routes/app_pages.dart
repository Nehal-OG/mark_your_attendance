import 'package:get/get.dart';
import 'package:mark_your_attendance/core/routes/app_routes.dart';

// Auth
import 'package:mark_your_attendance/features/auth/presentation/bindings/splash_binding.dart';
import 'package:mark_your_attendance/features/auth/presentation/views/splash_view.dart';
import 'package:mark_your_attendance/features/auth/presentation/views/login_view.dart';
import 'package:mark_your_attendance/features/auth/presentation/bindings/registration_binding.dart';
import 'package:mark_your_attendance/features/auth/presentation/views/registration_view.dart';
import 'package:mark_your_attendance/features/auth/presentation/bindings/login_binding.dart';
import 'package:mark_your_attendance/features/auth/presentation/bindings/password_reset_binding.dart';
import 'package:mark_your_attendance/features/auth/presentation/views/password_reset_view.dart';
import 'package:mark_your_attendance/features/auth/presentation/views/verify_otp_view.dart';

// Main Navigation
import 'package:mark_your_attendance/features/navigation/presentation/bindings/navigation_binding.dart';
import 'package:mark_your_attendance/features/navigation/presentation/views/main_navigation.dart';

// Home
import 'package:mark_your_attendance/features/home/presentation/bindings/home_binding.dart';
import 'package:mark_your_attendance/features/home/presentation/views/home_view.dart';

// Calendar
import 'package:mark_your_attendance/features/calendar/presentation/bindings/calendar_binding.dart';
import 'package:mark_your_attendance/features/calendar/presentation/views/calendar_view.dart';

// More
import 'package:mark_your_attendance/features/more/presentation/bindings/more_binding.dart';
import 'package:mark_your_attendance/features/more/presentation/views/more_view.dart';
import 'package:mark_your_attendance/features/more/presentation/views/my_attendance_view.dart';
import 'package:mark_your_attendance/features/more/presentation/views/change_password_view.dart';

class AppPages {
  static final routes = [
    // Auth Routes
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
      name: AppRoutes.VERIFY_OTP,
      page: () => VerifyOTPView(),
      binding: RegistrationBinding(),
    ),
    GetPage(
      name: AppRoutes.FORGOT_PASSWORD,
      page: () => PasswordResetView(),
      binding: PasswordResetBinding(),
    ),

    // Main Navigation Route
    GetPage(
      name: AppRoutes.MAIN,
      page: () => const MainNavigation(),
      binding: NavigationBinding(),
      children: [
        GetPage(
          name: AppRoutes.HOME,
          page: () => const HomeView(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: AppRoutes.CALENDAR,
          page: () => const CalendarView(),
          binding: CalendarBinding(),
        ),
        GetPage(
          name: AppRoutes.MORE,
          page: () => const MoreView(),
          binding: MoreBinding(),
          children: [
            GetPage(
              name: AppRoutes.MY_ATTENDANCE,
              page: () => const MyAttendanceView(),
              binding: MoreBinding(),
            ),
            GetPage(
              name: AppRoutes.CHANGE_PASSWORD,
              page: () => ChangePasswordView(),
              binding: MoreBinding(),
            ),
          ],
        ),
      ],
    ),
  ];

  // Initial Route
  static const INITIAL = AppRoutes.SPLASH;
} 
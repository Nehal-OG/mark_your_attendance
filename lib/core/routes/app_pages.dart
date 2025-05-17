import 'package:get/get.dart';
import '../../features/auth/bindings/auth_binding.dart';
import '../../features/auth/views/login_screen.dart';
import '../../features/auth/views/signin_screen.dart';
import '../../features/home/bindings/home_binding.dart';
import '../../features/home/views/home_screen.dart';
import '../../features/calendar/bindings/calendar_binding.dart';
import '../../features/calendar/views/calendar_screen.dart';
import '../../features/more/bindings/more_binding.dart';
import '../../features/more/views/more_screen.dart';
import '../../features/splash/views/splash_screen.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.SPLASH;

  static final routes = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.SIGNIN,
      page: () => const SignInScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.CALENDAR,
      page: () => const CalendarScreen(),
      binding: CalendarBinding(),
    ),
    GetPage(
      name: AppRoutes.MORE,
      page: () => const MoreScreen(),
      binding: MoreBinding(),
    ),
  ];
} 
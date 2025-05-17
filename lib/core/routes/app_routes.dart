part of 'app_pages.dart';

abstract class AppRoutes {
  // Auth AppRoutes
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const SIGNIN = '/signin';
  static const REGISTER = '/register';
  static const VERIFY_OTP = '/verify-otp';
  static const FORGOT_PASSWORD = '/forgot-password';
  
  // Main Navigation AppRoutes
  static const MAIN = '/main';
  static const HOME = '/home';
  static const CALENDAR = '/calendar';
  static const MORE = '/more';
  
  // Sub AppRoutes
  static const MY_ATTENDANCE = '/my-attendance';
  static const CHANGE_PASSWORD = '/change-password';
  static const UPDATE_PHONE = '/update-phone';
} 
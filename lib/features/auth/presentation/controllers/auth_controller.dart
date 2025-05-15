import 'package:get/get.dart';
import 'package:mark_your_attendance/features/auth/data/models/user_model.dart';
import 'package:mark_your_attendance/features/auth/domain/repositories/auth_repository.dart';
import 'package:mark_your_attendance/core/routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;
  final _user = Rxn<UserModel>();
  final _isLoading = false.obs;

  AuthController(this._authRepository);

  UserModel? get user => _user.value;
  bool get isLoading => _isLoading.value;

  Future<void> login(String email, String password) async {
    try {
      _isLoading.value = true;
      final user = await _authRepository.login(email, password);
      _user.value = user;
      Get.offAllNamed(AppRoutes.HOME);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      _isLoading.value = true;
      final user = await _authRepository.register(name, email, password);
      _user.value = user;
      Get.offAllNamed(AppRoutes.HOME);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
      _user.value = null;
      Get.offAllNamed(AppRoutes.LOGIN);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
} 
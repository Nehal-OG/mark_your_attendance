import 'package:get/get.dart';
import 'package:mark_your_attendance/features/navigation/presentation/controllers/navigation_controller.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NavigationController());
  }
} 
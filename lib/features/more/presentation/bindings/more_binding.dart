import 'package:get/get.dart';
import 'package:mark_your_attendance/features/more/data/services/more_service.dart';
import 'package:mark_your_attendance/features/more/presentation/controllers/more_controller.dart';

class MoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MoreService());
    Get.put(MoreController(Get.find<MoreService>()));
  }
} 
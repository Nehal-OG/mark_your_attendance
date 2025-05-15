import 'package:get/get.dart';

class NavigationController extends GetxController {
  final _selectedIndex = 0.obs;

  int get selectedIndex => _selectedIndex.value;

  void changePage(int index) {
    _selectedIndex.value = index;
  }
} 
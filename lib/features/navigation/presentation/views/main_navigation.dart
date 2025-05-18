import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mark_your_attendance/features/calendar/views/calendar_screen.dart';
import 'package:mark_your_attendance/features/home/views/home_screen.dart';
import 'package:mark_your_attendance/features/more/views/more_screen.dart';
import 'package:mark_your_attendance/features/navigation/presentation/controllers/navigation_controller.dart';


class MainNavigation extends GetView<NavigationController> {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.selectedIndex,
            children: const [
              HomeScreen(),
              CalendarScreen(),
              MoreScreen(),
            ],
          )),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: controller.selectedIndex,
          onDestinationSelected: controller.changePage,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined),
              selectedIcon: Icon(Icons.calendar_month_rounded),
              label: 'Calendar',
            ),
            NavigationDestination(
              icon: Icon(Icons.more_horiz_outlined),
              selectedIcon: Icon(Icons.more_horiz_rounded),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }
} 
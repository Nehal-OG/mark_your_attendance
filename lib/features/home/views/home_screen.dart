import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mark_your_attendance/core/routes/app_pages.dart';
import '../controllers/home_controller.dart';
import 'package:intl/intl.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => Get.toNamed(AppRoutes.CALENDAR),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => Get.toNamed(AppRoutes.MORE),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/images/splash_logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 24),
            Obx(() => Text(
                  controller.userName.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                )),
            const SizedBox(height: 8),
            Obx(() => Text(
                  DateFormat('EEEE, MMMM d, yyyy\nhh:mm a')
                      .format(controller.currentTime.value),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                )),
            const SizedBox(height: 48),
            Obx(() {
              if (controller.attendanceStatus.value == 'Checked In') {
                return ElevatedButton(
                  onPressed: controller.checkOut,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Check Out'),
                );
              } else if (controller.attendanceStatus.value == 'Checked Out') {
                return const Text(
                  'You have completed your attendance for today',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.green),
                );
              } else {
                return ElevatedButton(
                  onPressed: controller.checkIn,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Check In'),
                );
              }
            }),
            const SizedBox(height: 24),
            Obx(() {
              if (controller.checkInTime.isNotEmpty) {
                return Column(
                  children: [
                    Text('Check In Time: ${controller.checkInTime.value}'),
                    if (controller.checkOutTime.isNotEmpty)
                      Text('Check Out Time: ${controller.checkOutTime.value}'),
                    Text('Status: ${controller.attendanceStatus.value}'),
                    const SizedBox(height: 16),
                    const Text('Registered Location:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                        'Lat: ${controller.registeredLat.value.toStringAsFixed(6)}'),
                    Text(
                        'Lng: ${controller.registeredLng.value.toStringAsFixed(6)}'),
                    const SizedBox(height: 8),
                    const Text('Current Location:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                        'Lat: ${controller.currentLat.value.toStringAsFixed(6)}'),
                    Text(
                        'Lng: ${controller.currentLng.value.toStringAsFixed(6)}'),
                  ],
                );
              }
              return const SizedBox();
            }),
          ],
        ),
      ),
    );
  }
}

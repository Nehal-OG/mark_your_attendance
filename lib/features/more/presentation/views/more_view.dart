import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mark_your_attendance/features/more/presentation/controllers/more_controller.dart';
import 'package:mark_your_attendance/features/more/presentation/views/change_password_view.dart';
import 'package:mark_your_attendance/features/more/presentation/views/my_attendance_view.dart';

class MoreView extends GetView<MoreController> {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // My Attendance
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('My Attendance'),
                subtitle: const Text('View your attendance history'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  controller.loadAttendanceRecords();
                  Get.to(() => const MyAttendanceView());
                },
              ),
            ),
            const SizedBox(height: 16),

            // Change Password
            Card(
              child: ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Change Password'),
                subtitle: const Text('Update your account password'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Get.to(() => ChangePasswordView());
                },
              ),
            ),
            const SizedBox(height: 16),

            // Logout
            Card(
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                subtitle: const Text('Sign out from your account'),
                onTap: () {
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Confirm Logout'),
                      content: const Text(
                        'Are you sure you want to logout?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back();
                            controller.logout();
                          },
                          child: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
} 
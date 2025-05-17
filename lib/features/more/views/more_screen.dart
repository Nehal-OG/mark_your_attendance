import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/more_controller.dart';
import 'package:pinput/pinput.dart';

class MoreScreen extends GetView<MoreController> {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('My Attendance'),
            onTap: () => _showAttendanceRecords(context),
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Update Phone Number'),
            onTap: () => _showUpdatePhoneDialog(context),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }

  void _showAttendanceRecords(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Attendance Records',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: controller.attendanceRecords.length,
                    itemBuilder: (context, index) {
                      final record = controller.attendanceRecords[index];
                      return Card(
                        child: ListTile(
                          title: Text('Date: ${record['date']}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Check In: ${record['checkInTime']}'),
                              if (record['checkOutTime'].isNotEmpty)
                                Text('Check Out: ${record['checkOutTime']}'),
                              Text('Status: ${record['status']}'),
                            ],
                          ),
                        ),
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdatePhoneDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Phone Number'),
        content: Obx(() => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller.oldPhoneController,
                  decoration: const InputDecoration(
                    labelText: 'Old Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  enabled: false,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller.newPhoneController,
                  decoration: const InputDecoration(
                    labelText: 'New Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                if (controller.verificationId.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Pinput(
                    length: 6,
                    controller: controller.otpController,
                    onCompleted: (pin) =>
                        controller.verifyOTP(context),
                  ),
                ],
                if (controller.error.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      controller.error.value,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            )),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          Obx(() => TextButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.verificationId.isEmpty
                        ? controller.sendOTP()
                        : controller.verifyOTP(context),
                child: Text(controller.verificationId.isEmpty
                    ? 'Send OTP'
                    : 'Update'),
              )),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => controller.signOut(),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
} 
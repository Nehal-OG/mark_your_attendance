import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mark_your_attendance/features/more/presentation/controllers/more_controller.dart';

class MyAttendanceView extends GetView<MoreController> {
  const MyAttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Attendance'),
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.attendanceRecords.isEmpty) {
          return const Center(
            child: Text('No attendance records found'),
          );
        }

        return ListView.builder(
          itemCount: controller.attendanceRecords.length,
          itemBuilder: (context, index) {
            final record = controller.attendanceRecords[index];
            final date = DateFormat('EEEE, MMMM d, y').format(record.checkInTime);
            final checkIn = DateFormat('hh:mm a').format(record.checkInTime);
            final checkOut = record.checkOutTime != null
                ? DateFormat('hh:mm a').format(record.checkOutTime!)
                : '---';

            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  date,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Check In',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              checkIn,
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Check Out',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              checkOut,
                              style: TextStyle(
                                color: record.checkOutTime != null
                                    ? Colors.red
                                    : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Status',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: record.status == 'checked_in'
                                    ? Colors.green.shade100
                                    : Colors.red.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                record.status.toUpperCase(),
                                style: TextStyle(
                                  color: record.status == 'checked_in'
                                      ? Colors.green.shade900
                                      : Colors.red.shade900,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
} 
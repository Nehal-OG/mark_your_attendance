import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mark_your_attendance/features/home/presentation/controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  const SizedBox(height: 32),
                  const Icon(
                    Icons.location_on_rounded,
                    size: 80,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 24),

                  // User Name
                  Text(
                    'Welcome, ${controller.userName}',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Current Date & Time
                  Text(
                    DateFormat('EEEE, MMMM d, y').format(controller.currentTime),
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat('hh:mm:ss a').format(controller.currentTime),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Check In/Out Button
                  if (!controller.isCheckedIn)
                    ElevatedButton.icon(
                      onPressed: controller.checkIn,
                      icon: const Icon(Icons.login),
                      label: const Text('Check In'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: controller.checkOut,
                      icon: const Icon(Icons.logout),
                      label: const Text('Check Out'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ),
                  const SizedBox(height: 32),

                  // Status Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Today\'s Status',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Divider(),
                          if (controller.todayAttendance != null) ...[
                            _buildStatusRow(
                              'Check In Time:',
                              DateFormat('hh:mm a').format(
                                controller.todayAttendance!.checkInTime,
                              ),
                            ),
                            if (controller.todayAttendance!.checkOutTime != null)
                              _buildStatusRow(
                                'Check Out Time:',
                                DateFormat('hh:mm a').format(
                                  controller.todayAttendance!.checkOutTime!,
                                ),
                              ),
                            _buildStatusRow(
                              'Status:',
                              controller.todayAttendance!.status.toUpperCase(),
                            ),
                          ] else
                            const Text('No attendance recorded for today'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Location Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Location Details',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Divider(),
                          if (controller.currentPosition != null) ...[
                            _buildStatusRow(
                              'Current Latitude:',
                              controller.currentPosition!.latitude.toStringAsFixed(6),
                            ),
                            _buildStatusRow(
                              'Current Longitude:',
                              controller.currentPosition!.longitude.toStringAsFixed(6),
                            ),
                          ] else
                            const Text('Fetching location...'),
                          if (controller.todayAttendance?.checkInLocation != null) ...[
                            const SizedBox(height: 8),
                            const Divider(),
                            _buildStatusRow(
                              'Check-in Latitude:',
                              controller.todayAttendance!.checkInLocation.latitude
                                  .toStringAsFixed(6),
                            ),
                            _buildStatusRow(
                              'Check-in Longitude:',
                              controller.todayAttendance!.checkInLocation.longitude
                                  .toStringAsFixed(6),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
} 
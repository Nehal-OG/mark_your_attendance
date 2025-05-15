import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalendarView extends GetView {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.calendar_month_rounded,
              size: 100,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 16),
            Text(
              'Attendance Calendar',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Your attendance history will appear here',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:mark_your_attendance/features/calendar/presentation/controllers/calendar_controller.dart';

class CalendarView extends GetView<CalendarController> {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Calendar'),
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Calendar
            TableCalendar(
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(2025, 12, 31),
              focusedDay: controller.focusedDay,
              selectedDayPredicate: (day) =>
                  isSameDay(controller.selectedDay, day),
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                weekendTextStyle: const TextStyle(color: Colors.red),
                holidayTextStyle: const TextStyle(color: Colors.red),
                todayDecoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
              onDaySelected: controller.onDaySelected,
              onPageChanged: controller.onPageChanged,
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  return Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: controller.getDateColor(day),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(),

            // Legend
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildLegendItem('Present', Colors.green.shade100),
                  _buildLegendItem('Absent', Colors.red.shade100),
                  _buildLegendItem('Weekend', Colors.grey.shade200),
                  _buildLegendItem('Future', Colors.white),
                ],
              ),
            ),

            // Selected Day Details
            if (controller.selectedDay != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Selected Date: ${DateFormat('EEEE, MMMM d, y').format(controller.selectedDay!)}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Divider(),
                        _buildAttendanceDetails(controller.selectedDay!),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.grey),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }

  Widget _buildAttendanceDetails(DateTime date) {
    final attendance = controller.getAttendanceForDay(date);

    if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
      return const Text('Weekend');
    }

    if (date.isAfter(DateTime.now())) {
      return const Text('Future date');
    }

    if (attendance == null) {
      return const Text('No attendance record');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Check-in: ${DateFormat('hh:mm a').format(attendance.checkInTime)}'),
        if (attendance.checkOutTime != null)
          Text('Check-out: ${DateFormat('hh:mm a').format(attendance.checkOutTime!)}'),
        Text('Status: ${attendance.status.toUpperCase()}'),
      ],
    );
  }
} 
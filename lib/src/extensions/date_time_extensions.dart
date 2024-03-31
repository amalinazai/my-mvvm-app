import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime? {
  String? formatDateAndTime([String dateTimeFormat = 'd-MMMM-y | hh:mma']) {
    if (this != null) {
      final localTime = this!.toLocal();
      final format = DateFormat(dateTimeFormat);

      return format.format(localTime);
    } else {
      return null;
    }
  }

  String? getDayString() {
    if (this != null) {
      final localTime = this!.toLocal();
      final today = DateTime.now().toLocal();
      final tomorrow = today.add(const Duration(days: 1));
      if(localTime == today){
        return 'TODAY, ';
      }else if(localTime == tomorrow){
        return 'TOMORROW, ';
      }else{
        return '';
      }
    } else {
      return '';
    }
  }

  String greeting() {
    final hour = this!.hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }
}

extension TimeExtensions on TimeOfDay? {
  String formatTimeOfDay() {
    if(this == null) return '';

    // Extract the hour, minute, and period
    final hour = this!.hourOfPeriod;
    final minute = this!.minute;
    final period = this!.period == DayPeriod.am ? 'AM' : 'PM';

    // Convert the hour to 12-hour format
    final hourIn12HourFormat = hour == 0 ? 12 : hour;

    final formattedHour = hourIn12HourFormat.toString().padLeft(2, '0');

    final formattedMinute = minute.toString().padLeft(2, '0');

    return '$formattedHour:$formattedMinute $period';
  }
}


extension DateCompare on DateTime {
  bool isAtLeast(DateTime other) {
    return !isBefore(other);
  }

  bool isAtMost(DateTime other) {
    return !isAfter(other);
  }
}

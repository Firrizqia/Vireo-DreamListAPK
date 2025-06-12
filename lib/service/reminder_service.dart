import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vireo/db/db_helper.dart';
import 'package:vireo/models/dream_model.dart';
import 'package:intl/intl.dart';

final dateFormat = DateFormat('d MMMM yyyy');

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> checkDreamReminders() async {
  final List<Dream> dreams = await DatabaseHelper().getDreams();

  final now = DateTime.now();
  final besok = DateTime(now.year, now.month, now.day + 1);

  for (final dream in dreams) {
    try {
      final dueDate = dateFormat.parse(dream.date); // konversi dari string

      final tanggalTarget = DateTime(dueDate.year, dueDate.month, dueDate.day);

      if (tanggalTarget == besok) {
        await showReminderNotification(dream.title);
      }
    } catch (e) {
      // Handle error jika format tanggal salah
      print('Format tanggal salah untuk mimpi: ${dream.title}');
    }
  }
}

Future<void> showReminderNotification(String dreamTitle) async {
  const androidDetails = AndroidNotificationDetails(
    'reminder_channel',
    'Reminder Notifications',
    channelDescription: 'Reminder sebelum deadline mimpi',
    importance: Importance.high,
    priority: Priority.high,
  );

  const details = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    'Reminder Mimpi',
    'Besok adalah deadline mimpi: $dreamTitle',
    details,
  );
}

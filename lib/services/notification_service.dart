import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _plugin.initialize(settings);
  }

  Future<void> showEventReminder(String title, String body) async {
    await _plugin.show(
      100,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails('events', 'Event reminders'),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}

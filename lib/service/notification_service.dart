import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzData;
import 'package:timezone/timezone.dart' as tz;

const String channelId = "1000";
const String channelName = "feeding";
const String channelDescription = "feeding routine";

class NotificationService {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationService();

  void initialize() {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('ic_launcher');
    tzData.initializeTimeZones();

    var initializationSettingsIOS = DarwinInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) {
      print("onDidReceiveLocalNotification called.");
    });
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) {
      // when user tap on notification.
      print("onSelectNotification called.");
    });
  }

  sendNotification() async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        channelId, channelName,
        channelDescription: channelDescription);
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(111, 'Hello, benznest.',
        'This is a your notifications. ', platformChannelSpecifics,
        payload: 'I just haven\'t Met You Yet');
  }

  cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> setRoutine(DateTime startTime, int hourDuration) async {
    await cancelAll();
    var time = startTime;
    for (int i = 0; i < (24 / hourDuration); i++) {
      var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
          channelId, channelName,
          channelDescription: channelDescription);
      var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();

      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.zonedSchedule(
          i,
          '🍼 Baby Feeding Time',
          'It\'s feeding time! A well-fed baby is a happy baby.',
          _nextInstanceOfTime(time.hour, time.minute),
          platformChannelSpecifics,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents
              .time); // Matches only time component for daily repetition

      time = DateTime(0, 0, 0, time.hour + hourDuration % 24, time.minute,
          0); // Increment by 2 hours
    }
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.getLocation('Asia/Bangkok'),
        now.year, now.month, now.day, hour, minute);
    return scheduledDate;
  }
}

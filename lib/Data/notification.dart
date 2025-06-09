import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin _notificationsPlugin =
    FlutterLocalNotificationsPlugin();

void initializeNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings settings = InitializationSettings(
    android: androidSettings,
  );
  await _notificationsPlugin.initialize(settings);
}

/// Scheduled Notification
scheduledNotification(
  String title,
  String body,
  int id,
  int day,
  int hour,
  int second,
) async {
  var t = tz.TZDateTime.now(tz.local).add(
    Duration(
      seconds: second,
      hours: hour, //morning 6 after 00:00
      days: day,
    ),
  );
  await _notificationsPlugin.zonedSchedule(
    id,
    title,
    body,
    t,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'your channel id',
        'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.alarmClock,
  );
}

//TODO : Future Scope

  // Future<void> _deleteNotificationChannel() async {
  //   const String channelId = 'your channel id';
  //   await _notificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin
  //       >()
  //       ?.deleteNotificationChannel(channelId);

  //   await showDialog<void>(
  //     context: context,
  //     builder:
  //         (BuildContext context) => AlertDialog(
  //           content: const Text('Channel with id $channelId deleted'),
  //           actions: <Widget>[
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: const Text('OK'),
  //             ),
  //           ],
  //         ),
  //   );
  // }


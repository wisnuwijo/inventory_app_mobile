import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  init() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (notication) {}
    );
  }

  show({
    String title,
    String body,
    String payload = ''
  }) async {
    await this.init();
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Inventory-app-id', 'Inventory-app-name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker'
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics
    );

    await flutterLocalNotificationsPlugin.show(
      0, 
      title, 
      body, 
      platformChannelSpecifics,
      payload: payload
    );
  }
}
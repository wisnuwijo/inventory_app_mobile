import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:inventory_app/app/api/user_api.dart';
import 'package:inventory_app/app/helper/local_notification.dart';

Future<void> onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class FCM {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final streamCtlr = StreamController<String>.broadcast();
  final titleCtlr = StreamController<String>.broadcast();
  final bodyCtlr = StreamController<String>.broadcast();

  setNotifications() {
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        String _title = message.notification.title;
        String _body = message.notification.body;

        if (message.data.containsKey('data')) {
          // Handle data message
          streamCtlr.sink.add(message.data['data']);
        }
        if (message.data.containsKey('notification')) {
          // Handle notification message
          streamCtlr.sink.add(message.data['notification']);
        }

        print('_title.isNotEmpty && _body.isNotEmpty : ${_title.isNotEmpty && _body.isNotEmpty}');
        if (_title.isNotEmpty && _body.isNotEmpty) {
          await LocalNotification().show(
            body: _body,
            title: _title
          );
        }

        // Or do other work.
        titleCtlr.sink.add(message.notification.title);
        bodyCtlr.sink.add(message.notification.body);
      },
    );
    // With this token you can test it easily on your phone
    _firebaseMessaging.getToken().then((value) {
      print('TOKEN: $value');

      UserApi().updateToken(
        firebaseToken: value
      );
    });
  }

  dispose() {
    streamCtlr.close();
    bodyCtlr.close();
    titleCtlr.close();
  }
}
import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;


class NotificationManager{
final String serverToken = 'AAAAF7BBOIU:APA91bG98PEv6fPg2i9keG95iHtyAE1dKq-F2pCcS7ar0dMbqDUOoTyLB0ujbKbCjeSXJicbtRIY5YNSP234TWIyTHQyH6zXGV5fuJQYig33MLGB6lZst43aqzwm0gOd1WwmGGAhNC07';
final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

Future<Map<String, dynamic>> sendAndRetrieveMessage(String topic, String title, String body) async {
  await firebaseMessaging.requestPermission( sound: true, badge: true, alert: true, provisional: false);

  await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
     headers: <String, String>{
       'Content-Type': 'application/json',
       'Authorization': 'key=$serverToken',
     },
     body: jsonEncode(
     <String, dynamic>{
       'notification': <String, dynamic>{
         'body': '$body',
         'title': '$title'
       },
       'priority': 'high',
       'data': <String, dynamic>{
         'title' : '$title',
         'body' : '$body',
         'click_action': 'FLUTTER_NOTIFICATION_CLICK',
         'id': '${Timestamp.now().millisecondsSinceEpoch}',
         'status': 'done'
       },
       'to': '/topics/$topic',
     },
    ),
  );

  final Completer<Map<String, dynamic>> completer =
     Completer<Map<String, dynamic>>();

  return completer.future;
  }
}

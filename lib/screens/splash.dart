import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunny_connect/modals/users/current_app_user.dart';
import 'package:sunny_connect/screens/admin_specific/admin_dashboard.dart';
import 'package:sunny_connect/screens/authentication/login.dart';
import 'package:sunny_connect/screens/student_specfic/student_dashboard.dart';
import 'package:sunny_connect/screens/teacher_specific/teacher_dashboard.dart';
import 'package:sunny_connect/services/auth_service.dart';
import 'package:sunny_connect/src/constants/database_strings.dart';
import 'package:sunny_connect/utils/app_navigator.dart';
import 'package:sunny_connect/utils/colors.dart';
import 'dart:developer' as logger;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  // const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void onClose() async {
    AuthenticationService ser = AuthenticationService(FirebaseAuth.instance);
    String check = await ser.getCurrentUser();
    await Future.delayed(const Duration(seconds: 0));
    if (check == null) {
      if (CurrentAppUser.currentUserData.role == DatabaseStrings.SCHOOL_COL) {
        AppNavigator.makeFirst(context, const AdminDashboard());
      } else if (CurrentAppUser.currentUserData.role ==
          DatabaseStrings.TEACHER_COL) {
        AppNavigator.makeFirst(context, const TeacherDashboard());
      } else if (CurrentAppUser.currentUserData.role ==
          DatabaseStrings.STUDENT_COL) {
        AppNavigator.makeFirst(context, const StudentDashboard());
      } else {
        AppNavigator.makeFirst(context, const LoginScreen());
      }
    } else {
      AppNavigator.makeFirst(context, const LoginScreen());
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print("onMessage: $message");
        _showNotificationDialog(jsonDecode(message.notification.body));
      }
    });

    FirebaseMessaging.onBackgroundMessage((message) {
      if (message.notification != null) {
        print("onMessage: $message");
        _showNotificationDialog(jsonDecode(message.notification.body));
      }
    });

    Timer(const Duration(seconds: 2), onClose);
  }

  _showNotificationDialog(Map<String, dynamic> message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: Text("${message['data']['title']}"),
              content: Text("${message['data']['body']}"),
              actions: [
                RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Ok',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    // logger.log('Sgring1 ');
    // onClose();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(100),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png'),
            const SizedBox(height: 20),
            Text(
              'Sunny Connect',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  color: primaryBlue),
            )
          ],
        ),
      ),
    );
  }
}

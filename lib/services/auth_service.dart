import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunny_connect/modals/users/current_app_user.dart';
import 'package:sunny_connect/services/md5_covert.dart';
import 'package:sunny_connect/src/constants/database_strings.dart';
import 'package:sunny_connect/src/email_html.dart';
import 'package:sunny_connect/utils/widgets.dart';



class AuthenticationService extends ChangeNotifier{
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  /// Changed to idTokenChanges as it updates depending on more cases.
  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  Future<String> getCurrentUser()async{
    User user = _firebaseAuth.currentUser;
    if(user!=null){
      String userId= user.uid;
      SharedPreferences prefs= await SharedPreferences.getInstance();
      String role=prefs.getString('role')??'';
      try{
      return await CurrentAppUser.currentUserData.getCurrentUserData(role, userId);
      }catch(e){
        return "some error";
      }
    }
    return ' ';
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<User> signIn({String email, String password, String role}) async {
    ConnectivityResult connectivityResult =await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.toString(),
          password: password.toString(),
        );
        
        if (userCredential.user != null) {
          if(role==DatabaseStrings.TEACHER_COL){
            FirebaseFirestore.instance.collection('$role').doc(userCredential.user.uid).update({
              'change_code' : MD5Service.encodeMd5(password),
            });
          }
          String status=await CurrentAppUser().getCurrentUserData(role, userCredential.user.uid);
          if(status==null){
            return userCredential.user;
          }else{
            await FirebaseAuth.instance.signOut();
            Fluttertoast.showToast(
              msg: '$status!',
              gravity: ToastGravity.TOP,
            );
          }
          
        } else {
          return userCredential.user;
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Fluttertoast.showToast(
            msg: 'Email is not Registered!',
            gravity: ToastGravity.TOP,
          );
          print('No user found for that email');
        } else if (e.code == 'wrong-password') {
          Fluttertoast.showToast(
            msg: 'Incorrect Password!',
            gravity: ToastGravity.TOP,
          );
          print('Wrong password provided for that user');
        }
      } catch (e) {
        print("Here We got :: Error $e");
        Utilities.showToast('Unexpected Error $e!');
      }
    }else{
      Utilities.showToast('Failed! Internet not connected!');
      return null;
    }
  }

  Future<User> registerSchoolWithEmail({String email, String password, String name, String phone,String city, String country}) async {
    ConnectivityResult connectivityResult =await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        UserCredential userCredential= await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          DocumentReference userDoc = FirebaseFirestore.instance
          .collection(DatabaseStrings.SCHOOL_COL)
          .doc(userCredential.user.uid);
          await userDoc.set({
            'created_at': Timestamp.now(),
            'name': name,
            'id' : userCredential.user.uid,
            'email': email,
            'photo_url' : '',
            'phone' : phone,
            'city' : city,
            'country' : country,
            'status' : 1
          });
          
          return userCredential.user;
        } else {
          Fluttertoast.showToast(
            msg: 'Upexpected Error, Something went wrong!',
            gravity: ToastGravity.TOP,
          );
          return null;
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Fluttertoast.showToast(
            msg: 'Password is too weak!',
            gravity: ToastGravity.TOP,
          );
        } else if (e.code == 'email-already-in-use') {
          Fluttertoast.showToast(
            msg: 'Email already exists!',
            gravity: ToastGravity.TOP,
          );
        }
        return null;
      } catch (e) {
        Fluttertoast.showToast(
            msg: 'Upexpected Error, Something went wrong!',
            gravity: ToastGravity.TOP);
        return null;
      }
    }else{
      Utilities.showToast('Failed! Internet not connected!');
      return null;
    }
  }

  Future<User> signupStudentWithEmail({String email, String password, String name}) async {
    ConnectivityResult connectivityResult =await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        UserCredential userCredential= await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          DocumentReference userDoc = FirebaseFirestore.instance
              .collection(DatabaseStrings.STUDENT_COL)
              .doc('${userCredential.user.uid}');
          await userDoc.set({
            'created_at': Timestamp.now(),
            'name': name,
            'id' : userCredential.user.uid,
            'email': email,
            'photo_url' : '',
            'status': 1, 
          });
          return userCredential.user;
        } else {
          Fluttertoast.showToast(
            msg: 'Upexpected Error, Something went wrong!',
            gravity: ToastGravity.TOP,
          );
          return null;
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Fluttertoast.showToast(
            msg: 'Password is too weak!',
            gravity: ToastGravity.TOP,
          );
        } else if (e.code == 'email-already-in-use') {
          Fluttertoast.showToast(
            msg: 'Email already exists!',
            gravity: ToastGravity.TOP,
          );
        }
        return null;
      } catch (e) {
        print("Here we got Error $e");
        Fluttertoast.showToast(
            msg: 'Upexpected Error, Something went wrong!',
            gravity: ToastGravity.TOP);
        return null;
      }
    }else{
      Utilities.showToast('Failed! Internet not connected!');
      return null;
    }
  }

  Future<User> signupTeacherWithEmail(BuildContext ctx, {String email, String name, String department, String phone, String aboutme, String schoolId, String schoolName}) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    ConnectivityResult connectivityResult =await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        String password= getRandString();
        UserCredential userCredential= await FirebaseAuth.instanceFor(app: app).createUserWithEmailAndPassword(email: email, password: password);
        
        if (userCredential.user != null) {
          bool res= await sendEmail(email, name, password, schoolName);
          if(res){
            await app.delete();
            DocumentReference userDoc = FirebaseFirestore.instance
                .collection(DatabaseStrings.TEACHER_COL)
                .doc('${userCredential.user.uid}');
                await userDoc.set({
                  'created_at': Timestamp.now(),
                  'id' : userCredential.user.uid, 
                  'name': name,
                  'email': email,
                  'photo_url' : '',
                  'status': 1, 
                  'change_code' : MD5Service.encodeMd5(password),
                  'department' : department,
                  'phone' : phone, 
                  'about_me' : aboutme,
                  'school_id' : schoolId, 
                  'school_name' : schoolName,
                });
            
            return userCredential.user;
          }else{
            Utilities.showInfoDialog(ctx, 'Error 432!', 'Kindly contact admin to resolve this error!');
            await FirebaseAuth.instanceFor(app: app).currentUser.delete();
            await app.delete();
            return null;
          }
        } else {
          Fluttertoast.showToast(
            msg: 'Upexpected Error, Something went wrong!',
            gravity: ToastGravity.TOP,
          );
          return null;
        }
      } on FirebaseAuthException catch (e) {
        await app.delete();
        if (e.code == 'weak-password') {
          Fluttertoast.showToast(
            msg: 'Password is too weak!',
            gravity: ToastGravity.TOP,
          );
        } else if (e.code == 'email-already-in-use') {
          Fluttertoast.showToast(
            msg: 'Email already exists!',
            gravity: ToastGravity.TOP,
          );
        }
        return null;
      } catch (e) {
        await app.delete();
        print("Here we got Error $e");
        Fluttertoast.showToast(
            msg: 'Upexpected Error, Something went wrong!',
            gravity: ToastGravity.TOP);
        return null;
      }
    }else{
      Utilities.showToast('Failed! Internet not connected!');
      return null;
    }
  }


  static Future<bool> changeTeacherEmail(BuildContext ctx, String id, String name, String oldEmail, String email, String password)async{
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
      ConnectivityResult connectivityResult =await (Connectivity().checkConnectivity());
      if (connectivityResult != ConnectivityResult.none) {
        try {
          bool EXIST=await doesEmailExists(email, app);
          if(!EXIST){
            UserCredential userCredential= await FirebaseAuth.instanceFor(app: app).signInWithEmailAndPassword(email: oldEmail, password: password);
            if (userCredential.user != null) {
              bool res= await sendEmail(email, name, password, CurrentAppUser.currentUserData.name);
              if(res){
                bool updated=false;
                try{
                  await userCredential.user.updateEmail(email);
                  updated=true;
                }catch(e){
                  return Utilities.showToast('Failed with exception "$e"!');
                }
                await app.delete();
                DocumentReference userDoc = FirebaseFirestore.instance
                .collection(DatabaseStrings.TEACHER_COL)
                .doc('${userCredential.user.uid}');
                await userDoc.update({
                  'name': name,
                  'email': email,
                  'change_code' : MD5Service.encodeMd5(password),
                });
                return true;
              }else{
                Utilities.showInfoDialog(ctx, 'Error 432!', 'Kindly contact admin to resolve this error!');
                await FirebaseAuth.instanceFor(app: app).currentUser.delete();
                await app.delete();
                return false;
              }
            } else {
              Fluttertoast.showToast(
                msg: 'Upexpected Error, Something went wrong!',
                gravity: ToastGravity.TOP,
              );
              return false;
            }
          } else {
            await app.delete();
            Fluttertoast.showToast(
              msg: 'Email already exists, Change teacher\'s new email!',
              gravity: ToastGravity.TOP,
            );
            return false;
          }
        } on FirebaseAuthException catch (e) {
          await app.delete();
          if (e.code == 'weak-password') {
            Fluttertoast.showToast(
              msg: 'Password is too weak!',
              gravity: ToastGravity.TOP,
            );
          } else if (e.code == 'email-already-in-use') {
            Fluttertoast.showToast(
              msg: 'Email already exists!',
              gravity: ToastGravity.TOP,
            );
          }
          return null;
        } catch (e) {
          await app.delete();
          print("Here we got Error $e");
          Fluttertoast.showToast(
              msg: 'Upexpected Error, Something went wrong!',
              gravity: ToastGravity.TOP);
          return null;
        }
      }else{
        Utilities.showToast('Failed! Internet not connected!');
        return null;
      }
    }

  
  static Future<bool> doesEmailExists(String email, FirebaseApp app)async{
    List<String> list = await FirebaseAuth.instanceFor(app: app).fetchSignInMethodsForEmail(email);
    print('Here we gto Email :: $list');
    if(list.length>0){
      return true;
    }else{
      return false;
    }
  }
}



  Future<bool> sendEmail(String email, String name, String code, String school)async{
    String username = 'sunnyconnectapp@gmail.com';
    String password = 'Sunnyconnect01';

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Sunny Connect')
      ..recipients.add('$email')
      ..subject = 'Welcome to Sunny Connect,'
      ..text = 'Dear $name'
      ..html = getHTMLEmail(name, email, code, school);
    
    try {
      final sendReport = await send(message, smtpServer);
      return true;
    } on MailerException catch (e) {
      print("Here we got Exception $e");
      // Fluttertoast.showToast(
      //   msg: "Error with email! ${e.message}.",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.TOP,
      //     timeInSecForIosWeb: 3,
      //     fontSize: 16.0
      // );
      return false;
    }
  }

  String getRandString() {
    int len=6;
    var random = Random.secure();
    var values = List<int>.generate(len, (i) =>  random.nextInt(255));
    return base64UrlEncode(values);
  }


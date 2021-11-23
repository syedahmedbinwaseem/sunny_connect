import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sunny_connect/modals/users/current_app_user.dart';
import 'package:sunny_connect/src/constants/database_strings.dart';

class DatabaseServie {
  static Future<String> uploadImage(String userId, File image) async {
    try {
      TaskSnapshot task = await FirebaseStorage.instance
          .ref(
              'images/${userId.toString() + '_' + Timestamp.now().toString()}.png')
          .putFile(image);
      String url = await task.ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: 'Error ${e.code}: ${e.message}');
      return null;
    }
  }

  static Future<String> uploadFile(String userId, File image) async {
    try {
      TaskSnapshot task = await FirebaseStorage.instance
          .ref('posts/${image.path.split('/').last}')
          .putFile(image);
      String url = await task.ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: 'Error ${e.code}: ${e.message}');
      return null;
    }
  }

  static Future<bool> downloadFile(
      BuildContext context, String url, String savePath) async {
    BuildContext ctx;
    Dio dio = Dio();
    try {
      if (await Permission.storage.request().isGranted) {
        print("Here we got ::: File extension :::: ${savePath}");
        Response response = await dio.download(url, savePath);
        // // Navigator.pop(context);
        // print(response.headers);
        // File file = File(savePath);
        // var raf = file.openSync(mode: FileMode.write);
        // // response.data is List<int> type
        // raf.writeFromSync(response.data);
        // await raf.close();
        Fluttertoast.showToast(
            msg: 'File downloaded successfully in Downloads folder!');
        return true;
      } else {
        Fluttertoast.showToast(msg: 'Storage access denied!');
      }
    } catch (e) {
      // Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Error! $e!');
      return false;
    }
  }

  static Future<bool> updateImage(String role, String id, File file) async {
    String url = await DatabaseServie.uploadImage(id, file);
    if (url != null) {
      try {
        await FirebaseFirestore.instance.collection(role).doc(id).update({
          'photo_url': url,
        });
        CurrentAppUser.currentUserData.photoUrl = url;
        return true;
      } catch (e) {
        Fluttertoast.showToast(msg: 'Error ${e.code}: ${e.message}');
        return false;
      }
    }
  }

  static Future<bool> updateAdmindata(String id, String name, String phoneNo,
      String city, String country, String about) async {
    try {
      await FirebaseFirestore.instance
          .collection(DatabaseStrings.SCHOOL_COL)
          .doc(id)
          .update({
        'name': name,
        'phone': phoneNo,
        'city': city,
        'country': country,
        'about_me': about
      });
      CurrentAppUser.currentUserData.name = name;
      CurrentAppUser.currentUserData.phone = phoneNo;
      CurrentAppUser.currentUserData.city = city;
      CurrentAppUser.currentUserData.country = country;
      CurrentAppUser.currentUserData.aboutMe = about;
      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error ${e.code}: ${e.message}');
      return false;
    }
  }

  static Future<bool> updateTeacherdata(String id, String name, String phoneNo,
      String department, String about) async {
    try {
      await FirebaseFirestore.instance
          .collection(DatabaseStrings.TEACHER_COL)
          .doc(id)
          .update({
        'name': name,
        'phone': phoneNo,
        'department': department,
        'about_me': about
      });
      CurrentAppUser.currentUserData.name = name;
      CurrentAppUser.currentUserData.phone = phoneNo;
      CurrentAppUser.currentUserData.department = department;
      CurrentAppUser.currentUserData.aboutMe = about;
      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error ${e.code}: ${e.message}');
      return false;
    }
  }

  static Future<bool> updateStudentdata(String id, String name) async {
    try {
      await FirebaseFirestore.instance
          .collection(DatabaseStrings.STUDENT_COL)
          .doc(id)
          .update({
        'name': name,
      });
      CurrentAppUser.currentUserData.name = name;
      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error ${e.code}: ${e.message}');
      return false;
    }
  }

  static Future<bool> addStudentClass(String studentId, String classId) async {
    try {
      await FirebaseFirestore.instance
          .collection(DatabaseStrings.STUDENT_COL)
          .doc(studentId)
          .update({
        'class_ids': FieldValue.arrayUnion([classId])
      });
      CurrentAppUser.currentUserData.classes.add(classId);
      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error ${e.code}: ${e.message}');
      return false;
    }
  }

  static Future<String> validateClass(String name, String code) async {
    try {
      QuerySnapshot<Map<String, dynamic>> qs = await FirebaseFirestore.instance
          .collection(DatabaseStrings.CLASS_COL)
          .where('name', isEqualTo: name)
          .where('code', isEqualTo: code)
          .get();
      if (qs.docs.isNotEmpty) {
        return qs.docs.first.id;
      } else {
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error ${e.code}: ${e.message}');
      return null;
    }
  }
}

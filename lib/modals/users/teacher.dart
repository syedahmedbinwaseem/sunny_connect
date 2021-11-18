
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sunny_connect/src/constants/database_strings.dart';

class Teacher{
  String uid;
  String photoUrl;
  String name;
  String email;
  String phoneNo;
  String schoolId;
  String schoolName;
  String aboutMe;
  DateTime joinDate;
  int status;
  String changeCode;

  static Teacher fromMap(Map<String, dynamic> map){

    Teacher appUser=Teacher();
    appUser.email= map['email'];
    appUser.uid= map['id'];
    appUser.name= map['name'];
    appUser.photoUrl= map['photo_url'];
    appUser.schoolName = map['school_name'];
    appUser.aboutMe = map['about_me'];
    appUser.phoneNo = map['phone'];
    appUser.status = int.parse(map['status'].toString());
    appUser.joinDate = (map['created_at'] as Timestamp).toDate();
    appUser.changeCode = map['change_code']??'';
    return appUser;
  }


  static Future<Teacher> getTeacherWithId(String id)async{
    DocumentSnapshot doc= await FirebaseFirestore.instance.collection('teachers').doc('$id').get();
    return Teacher.fromMap(doc.data());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> streamTeachersWithSchool(String schoolId){
    return FirebaseFirestore.instance.collection(DatabaseStrings.TEACHER_COL).where('school_id', isEqualTo: schoolId).snapshots();
  }

}
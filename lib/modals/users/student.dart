import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sunny_connect/src/constants/database_strings.dart';

class Student{
  String uid;
  String email;
  String name; 
  DateTime createdAt;
  String photoUrl;
  String role;
  List<String> classes;
  

  Student({
    uid,
    email,
    name,
    createdAt,
    photoUrl,
    role,
    classes
  });
  

  static Student fromMap(Map<String, dynamic> map){

    Student appUser=Student();
    appUser.email= map['email'];
    appUser.uid= map['id'];
    appUser.name= map['name'];
    appUser.createdAt= map['created_at'];
    appUser.photoUrl= map['photo_url'];
  }


  static Future<Student> getStudentWithId(String id)async{
    DocumentSnapshot doc= await FirebaseFirestore.instance.collection('students').doc(id).get();
    return Student.fromMap(doc.data());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> studentPostFeeds(String id, List<String> classIds){
    // return FirebaseFirestore.instance.collection(DatabaseStrings.POST_COL).where('class_id', arrayContainsAny: classIds).orderBy('create_at').snapshots();
    return FirebaseFirestore.instance.collection(DatabaseStrings.POST_COL).snapshots();
  }

}


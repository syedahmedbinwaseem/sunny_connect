import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sunny_connect/modals/users/teacher.dart';
import 'package:sunny_connect/src/constants/database_strings.dart';

class AppClass{
  String id;
  String teacherId;
  String name; 
  String code;
  DateTime createdAt;
  int status;
  Teacher teacher;
  String description;
  

  AppClass({
    uid,
    email,
    name,
    createdAt,
    photoUrl,
    role
  });
  

  static AppClass fromMap(Map<String, dynamic> map){

    AppClass cl=AppClass();
    cl.name= map['name'];
    cl.id= map['class_id'];
    cl.description= map['description'];
    cl.code= map['code'];
    cl.status = int.parse(map['status'].toString());
    cl.teacherId= map['teacher_id'];
    cl.createdAt= (map['created_at'] as Timestamp).toDate();
    return cl;
  }


  static Future<AppClass> getAppClassWithId(String id)async{
    DocumentSnapshot doc= await FirebaseFirestore.instance.collection(DatabaseStrings.CLASS_COL).doc('$id').get();
    return AppClass.fromMap(doc.data());
  }


  static Stream<QuerySnapshot<Map<String, dynamic>>> streamAppClassWithTeacher(String id){
    return FirebaseFirestore.instance.collection(DatabaseStrings.CLASS_COL).where('teacher_id', isEqualTo: id).snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> streamStudentAppClass(List<String> classIds ){
    return FirebaseFirestore.instance.collection(DatabaseStrings.CLASS_COL).snapshots();
  }

  static Future<bool> addNewClass(String docId, String name, String code, String description, String teacherId)async{
    try{
      DocumentReference doc= FirebaseFirestore.instance.collection(DatabaseStrings.CLASS_COL).doc(docId);
      doc.set(
        {
          'class_id': doc.id,
          'name' : name,
          'code' : code,
          'status' : 1,
          'description' : description,
          'created_at' : Timestamp.now(),
          'teacher_id' : teacherId,
        }
      );
      return true;
    }catch(e){
      Fluttertoast.showToast(msg: 'Error ${e.code}: ${e.message}');
      return false;
    }
  }



}


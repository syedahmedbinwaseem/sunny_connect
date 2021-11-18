
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sunny_connect/src/constants/database_strings.dart';

class CurrentAppUser {
 static final CurrentAppUser _singleton = CurrentAppUser._internal();
 factory CurrentAppUser() => _singleton;
 CurrentAppUser._internal();
 static CurrentAppUser get currentUserData => _singleton;
  String uid;
  String email;
  String name; 
  DateTime createdAt;
  String photoUrl;
  String aboutMe;
  String role;

  String phone;
  String country;
  String city;
  
  //only for teacher
  String department;

  //Only for studnet
  List<String> classes=[];
  
  

  Future<String> getCurrentUserData(String userCol, String userId)async{
    try{
    // print("TRYING TO GRET :::: : $userCol, $userId");
    DocumentSnapshot<Map<String, dynamic>> userDoc= await FirebaseFirestore.instance.collection(userCol).doc(userId).get();
    print("Here we got Data ${userDoc.data()}");
    if(userDoc.data()['status'].toString()=='1'){
      CurrentAppUser.currentUserData.role=userCol;
      CurrentAppUser.currentUserData.email= userDoc.data()['email'];
      CurrentAppUser.currentUserData.uid= userId;
      CurrentAppUser.currentUserData.name= userDoc.data()['name'];
      CurrentAppUser.currentUserData.createdAt= (userDoc.data()['created_at'] as Timestamp).toDate();
      CurrentAppUser.currentUserData.photoUrl= userDoc.data()['photo_url'];
      CurrentAppUser.currentUserData.aboutMe= userDoc.data()['about_me'];
      CurrentAppUser.currentUserData.department= userDoc.data()['department'];

      //
      //
      // Fields for school
      CurrentAppUser.currentUserData.city= userDoc.data()['city'].toString();
      CurrentAppUser.currentUserData.country= userDoc.data()['country'].toString();
      CurrentAppUser.currentUserData.phone= userDoc.data()['phone'].toString();

      if(CurrentAppUser.currentUserData.role==DatabaseStrings.STUDENT_COL){
        print("Here we detected Student :::: ${userDoc.data()['class_ids']}");
        List<String> ids=[];
        List temp=userDoc.data()['class_ids']??[];
        for (var element in temp) {ids.add(element.toString());}
        CurrentAppUser.currentUserData.classes=ids;
      }
      return null;
    }else{
      return "User Blocked!";
    }
    }catch(e){
      return 'Error! Invalid user role selected!';
    }
  }
}


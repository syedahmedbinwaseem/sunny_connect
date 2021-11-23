import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sunny_connect/modals/app_class.dart';
import 'package:sunny_connect/src/constants/database_strings.dart';

class Post {
  String id;
  String title;
  String classId;
  String fileType;
  String fileUrl;
  DateTime createdAt;
  int status;
  String postType;
  bool isStreamActive;
  String authorId;
  String fileExtension;
  AppClass appClass;

  static Post fromMap(Map<String, dynamic> map) {
    Post post = Post();
    post.id = map['id'].toString();
    post.title = map['title'].toString();
    post.classId = map['class_id'].toString();
    post.fileType = map['file_type'].toString();
    post.fileUrl = map['file_url'].toString();
    post.createdAt = (map['created_at'] as Timestamp).toDate();
    post.status = int.parse(map['status'].toString());
    post.postType = map['post_type'].toString();
    post.isStreamActive = map['is_streaming'];
    post.authorId = map['author_id'].toString();
    post.fileExtension = map['file_extension'].toString();
    return post;
  }

  static Future<bool> addNewPost(
      String title,
      String userId,
      String classId,
      String fileType,
      String fileUrl,
      String postType,
      bool isStream,
      String fileExtension) async {
    try {
      DocumentReference doc =
          FirebaseFirestore.instance.collection(DatabaseStrings.POST_COL).doc();
      doc.set({
        'id': doc.id,
        'title': title,
        'class_id': classId,
        'file_type': fileType,
        'file_url': fileUrl,
        'created_at': Timestamp.now(),
        'status': 1,
        'post_type': postType,
        'is_streaming': isStream,
        'author_id': userId,
        'file_extension': fileExtension
      });
      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error ${e.code}: ${e.message}');
      return false;
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> streamPostWithClassId(
      String id) {
    return FirebaseFirestore.instance
        .collection(DatabaseStrings.POST_COL)
        .where('class_id', isEqualTo: id)
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  static Future<bool> deletePost(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection(DatabaseStrings.POST_COL)
          .doc(id)
          .delete();
      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error ${e.code}: ${e.message}');
      return false;
    }
  }
}

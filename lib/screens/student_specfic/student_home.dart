import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sunny_connect/modals/app_class.dart';
import 'package:sunny_connect/modals/app_post.dart';
import 'package:sunny_connect/modals/users/current_app_user.dart';
import 'package:sunny_connect/modals/users/student.dart';
import 'package:sunny_connect/services/database_service.dart';
import 'package:sunny_connect/src/constants/database_strings.dart';
import 'package:sunny_connect/utils/widgets.dart';
import 'package:sunny_connect/utils/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({Key key}) : super(key: key);

  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  bool isLoading;
  QuerySnapshot<Map<String, dynamic>> qs;
  Dio dio = Dio();
  @override
  void initState() {
    isLoading = true;
    FirebaseFirestore.instance
        .collection(DatabaseStrings.CLASS_COL)
        .get()
        .then((value) {
      qs = value;
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 25),
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: !isLoading
                ? SingleChildScrollView(
                    child: CurrentAppUser.currentUserData.classes.isNotEmpty
                        ? StreamBuilder<QuerySnapshot>(
                            stream: Student.studentPostFeeds(
                                CurrentAppUser.currentUserData.uid,
                                CurrentAppUser.currentUserData.classes),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text(AppLocalizations.of(context)
                                        .operation_failed));
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator(
                                        semanticsLabel: "Loading"));
                              }

                              if (snapshot.data.docs.isEmpty) {
                                return Center(
                                    child: Text(
                                        AppLocalizations.of(context)
                                            .no_post_text,
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                        )));
                              }
                              return Column(
                                children: snapshot.data.docs
                                    .map((DocumentSnapshot document) {
                                  Map<String, dynamic> data =
                                      document.data() as Map<String, dynamic>;
                                  if (CurrentAppUser.currentUserData.classes
                                      .contains((data['class_id']))) {
                                    return topCard(
                                        MediaQuery.of(context).size.height,
                                        MediaQuery.of(context).size.width,
                                        data);
                                  }
                                  return const SizedBox.shrink();
                                }).toList(),
                              );
                            },
                          )
                        : Center(
                            child: Text(
                                AppLocalizations.of(context).no_post_text)),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ),
      ),
    );
  }

  Widget topCard(double height, double width, Map<String, dynamic> data) {
    Post post = Post.fromMap(data);
    qs.docs.forEach((e) {
      post.appClass = AppClass.fromMap(e.data());
    });
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.all(20),
            width: width,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      post.appClass.name,
                      style: TextStyle(
                          fontSize: 16,
                          color: primaryBlue,
                          fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      DateFormat('MMM dd, yyyy').format(post.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: primaryBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    post.title.toString(),
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                _filePart(post, height, width)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _filePart(Post post, double height, double width) {
    return Container(
      child: post.postType == 'file'
          ? (post.fileType == 'image'
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: post.fileUrl,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.person),
                  ),
                )
              : Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      downloadFile_(context, post.fileUrl, post.fileExtension);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: primaryBlue),
                      height: width * 0.07,
                      width: width * 0.26,
                      child: Center(
                        child: Text(AppLocalizations.of(context).download,
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ),
                ))
          : const SizedBox.shrink(),
    );
  }

  downloadFile_(BuildContext context, String url, String extension) async {
    try {
      setState(() {
        isLoading = true;
      });
      Directory directory = Platform.isAndroid
          ? Directory(await ExtStorage.getExternalStoragePublicDirectory(
              ExtStorage.DIRECTORY_DOWNLOADS))
          : await getApplicationDocumentsDirectory();
      String str =
          'File_SC_${DateTime.now().year}_${DateTime.now().month}_${DateTime.now().day}_${DateTime.now().hour}_${DateTime.now().minute}_${DateTime.now().second}';
      // Directory directory2 = Directory(directory.path);

      bool res = await DatabaseServie.downloadFile(
          context, url, '${directory.path}/$str.$extension');
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'Downloading Failed! $e');
    }
  }

  Widget bottomLiveCard(double height, double width, String name) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(15)),
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                  fontSize: 16,
                  color: primaryBlue,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              'LIVE',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
            const SizedBox(height: 5),
            Container(
              height: width * 0.5,
              width: width,
              decoration: BoxDecoration(border: Border.all(color: Colors.red)),
            )
          ],
        ),
      ),
    );
  }
}

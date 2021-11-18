import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sunny_connect/modals/users/current_app_user.dart';
import 'package:sunny_connect/modals/users/teacher.dart';
import 'package:sunny_connect/screens/admin_specific/teacher_detail.dart';
import 'package:sunny_connect/utils/app_navigator.dart';
import 'package:sunny_connect/utils/widgets.dart';
import 'package:sunny_connect/utils/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TeachersAdmin extends StatefulWidget {
  const TeachersAdmin({Key key}) : super(key: key);

  @override
  _TeachersAdminState createState() => _TeachersAdminState();
}

class _TeachersAdminState extends State<TeachersAdmin> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 25),
          child: StreamBuilder<QuerySnapshot>(
            stream: Teacher.streamTeachersWithSchool(
                CurrentAppUser.currentUserData.uid),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: Text(AppLocalizations.of(context).operation_failed));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child:
                        CircularProgressIndicator(semanticsLabel: "Loading"));
              }

              return ListView(
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  return teacherCard(height, width, data);
                }).toList(),
              );
            },
          )
          // ScrollConfiguration(
          //   behavior: MyBehavior(),
          //   child: SingleChildScrollView(
          //     child: Column(
          //       children: [
          //         const SizedBox(height: 35),
          //         topCard(height, width, "Geography C", "07:05 pm", "Description",
          //             "July 3, 2021"),
          //         const SizedBox(height: 20),
          //         topCard(height, width, "Geography C", "07:05 pm", "Description",
          //             "July 3, 2021"),
          //         const SizedBox(height: 20),
          //         bottomLiveCard(height, width, "Geography C"),
          //         const SizedBox(height: 20),
          //       ],
          //     ),
          //   ),
          // ),
          ),
    );
  }

  Widget teacherCard(double height, double width, Map<String, dynamic> data) {
    Teacher teacher = Teacher.fromMap(data);
    return GestureDetector(
      onTap: () {
        AppNavigator.push(context, TeacherDetails(teacher: teacher));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.all(10),
            // height: width * 0.3,
            width: width,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: '${data['photo_url']}',
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      errorWidget: (context, url, error) => Icon(Icons.person),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: width - 110,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${data['name']}',
                            style: TextStyle(
                                fontSize: 16,
                                color: primaryBlue,
                                fontWeight: FontWeight.bold),
                          ),
                          // const Spacer(),
                          Text(
                            '${data['department']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: primaryBlue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '${data['about_me'] ?? 'No-Description added!'}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 12,
                            color: primaryBlue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            '✉ ${data['email']}',
                            style: TextStyle(
                                fontSize: 12,
                                color: primaryBlue,
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          // Text(
                          //   '#${data['phone']}',
                          //   style: TextStyle(
                          //     fontSize: 12,
                          //     color: primaryBlue,
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

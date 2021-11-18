import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sunny_connect/main.dart';
import 'package:sunny_connect/modals/app_class.dart';
import 'package:sunny_connect/modals/users/current_app_user.dart';
import 'package:sunny_connect/provider/languages_manager.dart';
import 'package:sunny_connect/screens/teacher_specific/add_class.dart';
import 'package:sunny_connect/screens/teacher_specific/teacher_profile.dart';
import 'package:sunny_connect/utils/app_navigator.dart';
import 'package:sunny_connect/utils/widgets.dart';
import 'package:sunny_connect/utils/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../classroom_feeds.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({Key key}) : super(key: key);

  @override
  _TeacherDashboardState createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int language;
  AppLanguage appLanguage = AppLanguage();
  @override
  void initState() {
    super.initState();
    appLanguage.fetchLocale().then((value) {
      language = (appLanguage.appLocal.languageCode == 'en') ? 1 : 2;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: primaryBlue,
        onPressed: () {
          AppNavigator.push(context, const AddNewClass());
        },
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
            child: Column(
          children: [
            topContainer(height, width),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: AppClass.streamAppClassWithTeacher(
                    CurrentAppUser.currentUserData.uid),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(AppLocalizations.of(context).post));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                            semanticsLabel: "Loading"));
                  }

                  if (snapshot.data.docs.isEmpty) {
                    return Center(
                        child: Text(AppLocalizations.of(context).no_post_text,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                            )));
                  }

                  return Column(
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      return classCard(MediaQuery.of(context).size.height,
                          MediaQuery.of(context).size.width, data);
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        )),
      ),
    );
  }

  Widget classCard(double height, double width, Map<String, dynamic> data) {
    AppClass appClass = AppClass.fromMap(data);
    return GestureDetector(
      onTap: () {
        AppNavigator.push(
            context,
            ClassRoomScreen(
              appClass: appClass,
            ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.all(10),
            width: width,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${appClass.name} ',
                      style: TextStyle(
                          fontSize: 16,
                          color: primaryBlue,
                          fontWeight: FontWeight.bold),
                    ),
                    // const Spacer(),
                    Text(
                      '${DateFormat('dd MMM, yyyy').format(appClass.createdAt)} ',
                      style: TextStyle(
                        fontSize: 12,
                        color: primaryBlue,
                      ),
                    ),
                  ],
                ),
                Text('#${appClass.code}', style: TextStyle(color: primaryBlue)),
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '${appClass.description ?? 'No-Description added!'} ',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget topContainer(double height, double width) {
    return SafeArea(
      child: Container(
        height: height * 0.3,
        width: width,
        color: primaryBlue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    height: 30,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (ctx) {
                                var appLanguage =
                                    Provider.of<AppLanguage>(context);
                                return Dialog(
                                    backgroundColor: Colors.white,
                                    child: Container(
                                      height: 100,
                                      child: Scaffold(
                                        body: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  RaisedButton(
                                                    onPressed: () {
                                                      appLanguage
                                                          .changeLanguage(
                                                              Locale("en"));
                                                    },
                                                    child: Text('English'),
                                                  ),
                                                  RaisedButton(
                                                    onPressed: () {
                                                      appLanguage
                                                          .changeLanguage(
                                                              Locale("ar"));
                                                    },
                                                    child: Text('العربي'),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                              });
                        },
                        child: const Icon(Icons.settings, color: Colors.white)),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    height: 30,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: GestureDetector(
                        onTap: () {
                          Utilities.showLogoutDialog(context);
                        },
                        child: const Icon(Icons.logout, color: Colors.white)),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                AppNavigator.push(context, const TeacherProfile());
              },
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.3 / 2.5,
                    width: height * 0.3 / 2.5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: CachedNetworkImage(
                        imageUrl: CurrentAppUser.currentUserData.photoUrl,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) => const Icon(
                            Icons.person,
                            size: 42,
                            color: Colors.white),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    '${CurrentAppUser.currentUserData.name}(${AppLocalizations.of(context).teacher})',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.email_outlined, color: Colors.white),
                      const SizedBox(width: 5),
                      Text(
                        CurrentAppUser.currentUserData.email.toString(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
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

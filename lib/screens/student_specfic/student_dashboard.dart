import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunny_connect/modals/users/current_app_user.dart';
import 'package:sunny_connect/provider/languages_manager.dart';
import 'package:sunny_connect/screens/admin_specific/admin_profile.dart';
import 'package:sunny_connect/screens/student_specfic/student_classrooms.dart';
import 'package:sunny_connect/screens/student_specfic/student_home.dart';
import 'package:sunny_connect/screens/student_specfic/student_profile.dart';
import 'package:sunny_connect/utils/app_navigator.dart';
import 'package:sunny_connect/utils/colors.dart';
import 'package:sunny_connect/utils/widgets.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({Key key}) : super(key: key);

  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: primaryBlue,
      body: Column(
        children: [topContainer(height, width), bottomContainer(height, width)],
      ),
    );
  }

  Widget topContainer(double height, double width) {
    return SafeArea(
      child: Container(
        height: height * 0.3 - 32,
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
                AppNavigator.push(context, const StudentProfile());
              },
              child: Column(children: [
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
                      errorWidget: (context, url, error) =>
                          Icon(Icons.person, size: 38, color: Colors.white),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  '${CurrentAppUser.currentUserData.name} ',
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
                      style: const TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomContainer(double height, double width) {
    return Container(
      height: height * 0.7,
      width: width,
      color: Colors.white,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.bold),
              labelColor: primaryBlue,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: MaterialIndicator(
                color: primaryBlue,
                paintingStyle: PaintingStyle.fill,
              ),
              indicatorWeight: 2,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: [
                Tab(
                  text: AppLocalizations.of(context).home,
                ),
                Tab(
                  text: AppLocalizations.of(context).classrooms,
                ),
              ],
            ),
            const Expanded(
                child: TabBarView(
              children: [StudentHome(), StudentClassrooms()],
            ))
          ],
        ),
      ),
    );
  }
}

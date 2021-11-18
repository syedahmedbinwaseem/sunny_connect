import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:sunny_connect/modals/app_class.dart';
import 'package:sunny_connect/modals/users/current_app_user.dart';
import 'package:sunny_connect/modals/users/student.dart';
import 'package:sunny_connect/screens/classroom_feeds.dart';
import 'package:sunny_connect/services/database_service.dart';
import 'package:sunny_connect/utils/app_navigator.dart';
import 'package:sunny_connect/utils/field_validator.dart';
import 'package:sunny_connect/utils/widgets.dart';
import 'package:sunny_connect/utils/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StudentClassrooms extends StatefulWidget {
  const StudentClassrooms({Key key}) : super(key: key);

  @override
  _StudentClassroomsState createState() => _StudentClassroomsState();
}

class _StudentClassroomsState extends State<StudentClassrooms> {
  List expanded = [false, false, false, false];
  final TextEditingController name = TextEditingController();
  final TextEditingController code = TextEditingController();

  bool isLoading;
  GlobalKey<FormState> fKey = GlobalKey<FormState>();

  @override
  void initState() {
    isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                const SizedBox(height: 10),
                // ignore: deprecated_member_use
                FlatButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return addClassRoom(height, width);
                        });
                  },
                  padding: const EdgeInsets.all(0),
                  color: primaryBlue,
                  focusColor: primaryBlue,
                  highlightColor: primaryBlue.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    height: width * 0.15,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_circle, color: Colors.white),
                        SizedBox(width: 15),
                        Text(AppLocalizations.of(context).add_class_appbar,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white))
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: AppClass.streamStudentAppClass(
                        CurrentAppUser.currentUserData.classes),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                            child: Text(
                          AppLocalizations.of(context).operation_failed,
                        ));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                                semanticsLabel: "Loading"));
                      }

                      if (snapshot.data.docs.isEmpty) {
                        return Center(
                            child: Text(
                                AppLocalizations.of(context)
                                    .no_class_joined_msg,
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                )));
                      }
                      List<QueryDocumentSnapshot<Object>> studentsRooms =
                          snapshot.data.docs.where((e) {
                        if (CurrentAppUser.currentUserData.classes
                            .contains(e.id)) {
                          return true;
                        } else {
                          return false;
                        }
                      }).toList();
                      if (studentsRooms.isEmpty) {
                        return Center(
                            child: Text(
                                AppLocalizations.of(context)
                                    .no_class_joined_msg,
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                )));
                      }
                      return ListView(
                        children:
                            studentsRooms.map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;
                          return classCard(MediaQuery.of(context).size.height,
                              MediaQuery.of(context).size.width, data);
                        }).toList(),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget classroomCard(double height, double width, int index, String className,
      String teacherName) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ClassRoomScreen()));
      },
      child: ExpansionPanelList(
        elevation: 2,
        dividerColor: primaryBlue,
        expansionCallback: (item, status) {
          setState(() {
            expanded[index] = !expanded[index];
          });
        },
        animationDuration: const Duration(milliseconds: 300),
        children: [
          ExpansionPanel(
            backgroundColor: Colors.grey.shade50,
            isExpanded: expanded[index],
            headerBuilder: (context, isExpanded) {
              return Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    className,
                    style: TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              );
            },
            body: Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Text(teacherName),
            ),
          ),
        ],
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

  Widget addClassRoom(double height, double width) {
    name.clear();
    code.clear();
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        height: width * 0.9,
        width: width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Form(
          key: fKey,
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context).add_class_appbar,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryBlue,
                    fontSize: 16),
              ),
              const SizedBox(height: 20),
              Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Utilities.textField(
                      AppLocalizations.of(context).class_name,
                      false,
                      TextInputAction.next,
                      name,
                      validtor: FieldValidator.validateField)),
              const SizedBox(height: 20),
              Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Utilities.textField(
                      AppLocalizations.of(context).class_code,
                      false,
                      TextInputAction.next,
                      code,
                      validtor: FieldValidator.validateField,
                      keyboardType: TextInputType.number)),
              const SizedBox(height: 40),
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () async {
                  if (fKey.currentState.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    AppNavigator.pop(context);

                    String classId = await DatabaseServie.validateClass(
                        name.text, code.text);
                    if (classId != null) {
                      bool check = await DatabaseServie.addStudentClass(
                          CurrentAppUser.currentUserData.uid, classId);
                      FirebaseMessaging firebaseMessaging =
                          FirebaseMessaging.instance;

                      firebaseMessaging.subscribeToTopic(classId);
                      setState(() {
                        isLoading = false;
                      });
                      if (check) {
                        Fluttertoast.showToast(
                          msg: AppLocalizations.of(context).class_added_title,
                        );
                      }
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                      Fluttertoast.showToast(
                          msg: 'No class Found! Invalid class name OR code!');
                    }
                  }
                },
                padding: const EdgeInsets.all(0),
                color: primaryBlue,
                focusColor: Colors.blue,
                highlightColor: Colors.blue.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(width * 0.13 / 2)),
                child: SizedBox(
                  height: width * 0.13,
                  width: width * 0.4,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).add,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

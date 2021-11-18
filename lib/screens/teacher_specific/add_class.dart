import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:sunny_connect/modals/app_class.dart';
import 'package:sunny_connect/modals/users/current_app_user.dart';
import 'package:sunny_connect/screens/authentication/login.dart';
import 'package:sunny_connect/screens/teacher_specific/teacher_dashboard.dart';
import 'package:sunny_connect/services/auth_service.dart';
import 'package:sunny_connect/src/constants/database_strings.dart';
import 'package:sunny_connect/utils/app_navigator.dart';
import 'package:sunny_connect/utils/field_validator.dart';
import 'package:sunny_connect/utils/widgets.dart';
import 'package:sunny_connect/utils/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddNewClass extends StatefulWidget {
  const AddNewClass({Key key}) : super(key: key);

  @override
  _AddNewClassState createState() => _AddNewClassState();
}

class _AddNewClassState extends State<AddNewClass> with WidgetsBindingObserver {
  bool textFieldSelected = false;

  TextEditingController code = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();

  GlobalKey<FormState> fKey = GlobalKey<FormState>();
  bool isLoading;
  bool isAutoValidate;
  String docId;

  @override
  void initState() {
    isLoading = false;
    isAutoValidate = false;
    docId = Timestamp.now().millisecondsSinceEpoch.toString();
    code.text = docId;
    setState(() {});
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final value = WidgetsBinding.instance.window.viewInsets.bottom;

    if (value == 0) {
      setState(() {
        textFieldSelected = false;
      });
    } else if (value > MediaQuery.of(context).size.height / 3) {
      setState(() {
        textFieldSelected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Class'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            bottom: 10,
          ),
          child: bottomContainer(height, width, () {}),
        ),
      ),
    );
  }

  Widget bottomContainer(double height, double width, Function() onTap) {
    return Form(
      key: fKey,
      autovalidate: isAutoValidate,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            const Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Center(
                  child: Text(
                'Add Your class here, and share Class Name and Code with your friends to join!',
                textAlign: TextAlign.center,
              )),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Utilities.textField(
                  "Class Name", false, TextInputAction.next, name,
                  validtor: FieldValidator.validateField),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Utilities.textField(
                  "Class Code", false, TextInputAction.next, code,
                  validtor: FieldValidator.validateFieldLen,
                  keyboardType: TextInputType.number,
                  readOnly: true,
                  maxLen: 5),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Utilities.textField(
                  "Description", false, TextInputAction.done, description,
                  validtor: FieldValidator.validateField, maxLines: 100),
            ),
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.centerRight,
              // ignore: deprecated_member_use
              child: FlatButton(
                onPressed: () async {
                  if (fKey.currentState.validate()) {
                    bool res = await AppClass.addNewClass(
                        docId,
                        name.text,
                        code.text,
                        description.text,
                        CurrentAppUser.currentUserData.uid);
                    if (res) {
                      await Utilities.showInfoDialog(context, 'New Class Added',
                          'Kindly share Class Code with your students to join!');
                      AppNavigator.makeFirst(context, const TeacherDashboard());
                      setState(() {
                        isLoading = false;
                      });
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  } else {
                    setState(() {
                      isAutoValidate = true;
                    });
                  }
                },
                padding: const EdgeInsets.all(0),
                color: primaryBlue,
                focusColor: Colors.blue,
                highlightColor: Colors.blue.withOpacity(0.1),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30))),
                child: Container(
                  height: width * 0.14,
                  width: width * 0.45,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30)),
                  ),
                  child: const Center(
                    child: Text(
                      'Add Class',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: width * 0.07),
          ],
        ),
      ),
    );
  }
}

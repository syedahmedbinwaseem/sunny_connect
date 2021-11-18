import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:sunny_connect/modals/users/current_app_user.dart';
import 'package:sunny_connect/screens/admin_specific/admin_dashboard.dart';
import 'package:sunny_connect/screens/authentication/login.dart';
import 'package:sunny_connect/services/auth_service.dart';
import 'package:sunny_connect/utils/app_navigator.dart';
import 'package:sunny_connect/utils/field_validator.dart';
import 'package:sunny_connect/utils/widgets.dart';
import 'package:sunny_connect/utils/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddNewTeacher extends StatefulWidget {
  const AddNewTeacher({Key key}) : super(key: key);

  @override
  _AddNewTeacherState createState() => _AddNewTeacherState();
}

class _AddNewTeacherState extends State<AddNewTeacher>
    with WidgetsBindingObserver {
  bool textFieldSelected = false;

  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController department = TextEditingController();
  TextEditingController aboutme = TextEditingController();

  GlobalKey<FormState> fKey = GlobalKey<FormState>();
  bool isLoading;
  bool isAutoValidate;

  @override
  void initState() {
    isLoading = false;
    isAutoValidate = false;

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
    double screenHeight = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double height2 = screenHeight - padding.top;
    double status = screenHeight - height2;
    double app = status + 60;
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 10),
              child: bottomContainer(height, width, () {}),
            )),
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
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Utilities.textField(
                  AppLocalizations.of(context).teacher_name,
                  false,
                  TextInputAction.next,
                  name,
                  validtor: FieldValidator.validateField),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Utilities.textField(
                  AppLocalizations.of(context).teacher_email,
                  false,
                  TextInputAction.next,
                  email,
                  validtor: FieldValidator.validateEmail),
            ),
            // const SizedBox(height: 10),
            // Padding(
            //   padding: const EdgeInsets.only(right: 20),
            //   child: Utilities.textField(
            //       "Teacher Phone", false, TextInputAction.next, phone, validtor:  FieldValidator.validateField, keyboardType: TextInputType.number),
            // ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Utilities.textField(
                  AppLocalizations.of(context).teacher_department,
                  false,
                  TextInputAction.next,
                  department,
                  validtor: FieldValidator.validateField),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Utilities.textField(
                  AppLocalizations.of(context).about_teacher,
                  false,
                  TextInputAction.done,
                  aboutme,
                  validtor: FieldValidator.validateField,
                  maxLines: 100),
            ),
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.centerRight,
              // ignore: deprecated_member_use
              child: FlatButton(
                onPressed: () async {
                  if (fKey.currentState.validate()) {
                    //
                    //validated
                    //
                    //Now Performing Teacher Registration
                    AuthenticationService service =
                        AuthenticationService(FirebaseAuth.instance);
                    setState(() {
                      isLoading = true;
                    });
                    //
                    User user = await service.signupTeacherWithEmail(context,
                        email: email.text,
                        name: name.text,
                        department: department.text,
                        phone: phone.text,
                        schoolId: CurrentAppUser.currentUserData.uid,
                        schoolName: CurrentAppUser.currentUserData.name,
                        aboutme: aboutme.text);

                    if (user != null) {
                      await Utilities.showInfoDialog(
                          context,
                          AppLocalizations.of(context).class_added_title,
                          AppLocalizations.of(context).class_added_text,
                          onTap: () {
                        AppNavigator.makeFirst(context, const AdminDashboard());
                      });
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
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).add_teacher,
                      style: const TextStyle(
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

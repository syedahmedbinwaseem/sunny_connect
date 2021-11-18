import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunny_connect/screens/admin_specific/admin_dashboard.dart';
import 'package:sunny_connect/screens/authentication/register_school.dart';
import 'package:sunny_connect/screens/authentication/reset_passowrd.dart';
import 'package:sunny_connect/screens/student_specfic/student_dashboard.dart';
import 'package:sunny_connect/screens/authentication/student_signup.dart';
import 'package:sunny_connect/screens/teacher_specific/teacher_dashboard.dart';
import 'package:sunny_connect/services/auth_service.dart';
import 'package:sunny_connect/src/constants/database_strings.dart';
import 'package:sunny_connect/utils/app_navigator.dart';
import 'package:sunny_connect/utils/field_validator.dart';
import 'package:sunny_connect/utils/widgets.dart';
import 'package:sunny_connect/utils/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  List<bool> selected = [false, false, true];
  bool textFieldSelected = false;

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

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

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

  BoxDecoration decoration = const BoxDecoration(
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
  );

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Stack(
          children: [
            topContainer(height, width),
            Align(
                alignment: Alignment.bottomCenter,
                child: bottomContainer(height, width, () {
                  selected[0]
                      ? null
                      : selected[1]
                          ? null
                          : selected[2]
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const StudentDashboard()))
                              : null;
                }))
          ],
        ),
      ),
    );
  }

  Widget topContainer(var height, var width) {
    return Container(
      padding: EdgeInsets.fromLTRB(width * 0.13, height * 0.125, 0, 10),
      height: height,
      width: width,
      color: primaryBlue,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: height * 0.17,
            width: height * 0.17,
            child: Image.asset('assets/images/logo.png'),
          ),
          const Spacer(),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                userSelection(
                    !selected[0]
                        ? MediaQuery.of(context).size.height * 0.045
                        : MediaQuery.of(context).size.height * 0.05,
                    !selected[0]
                        ? MediaQuery.of(context).size.width * 0.32
                        : MediaQuery.of(context).size.width * 0.4,
                    AppLocalizations.of(context).school, () {
                  adminSelect();
                }),
                const SizedBox(height: 10),
                userSelection(
                    !selected[1]
                        ? MediaQuery.of(context).size.height * 0.045
                        : MediaQuery.of(context).size.height * 0.05,
                    !selected[1]
                        ? MediaQuery.of(context).size.width * 0.32
                        : MediaQuery.of(context).size.width * 0.4,
                    AppLocalizations.of(context).teacher, () {
                  teacherSelect();
                }),
                const SizedBox(height: 10),
                userSelection(
                    !selected[2]
                        ? MediaQuery.of(context).size.height * 0.045
                        : MediaQuery.of(context).size.height * 0.05,
                    !selected[2]
                        ? MediaQuery.of(context).size.width * 0.32
                        : MediaQuery.of(context).size.width * 0.4,
                    AppLocalizations.of(context).student, () {
                  studentSelect();
                }),
                const SizedBox(height: 90),
              ],
            ),
          )
        ],
      ),
    );
  }

  void adminSelect() {
    setState(() {
      selected = [true, false, false];
    });
  }

  void teacherSelect() {
    setState(() {
      selected = [false, true, false];
    });
  }

  void studentSelect() {
    setState(() {
      selected = [false, false, true];
    });
  }

  Widget userSelection(
      double height, double width, String text, Function() onTap) {
    // ignore: deprecated_member_use
    return FlatButton(
      onPressed: onTap,
      padding: const EdgeInsets.all(0),
      color: Colors.white,
      focusColor: primaryBlue,
      highlightColor: primaryBlue.withOpacity(0.3),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), bottomLeft: Radius.circular(30))),
      child: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
        ),
        child: Center(
          child: Text(
            text,
            style:
                TextStyle(fontSize: width * 0.09, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget bottomContainer(var height, var width, Function() onTap) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(30, 20, 0, 20),
        width: width,
        height: height * 0.63,
        decoration: BoxDecoration(
          borderRadius: textFieldSelected == false
              ? const BorderRadius.only(topLeft: Radius.circular(120))
              : null,
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: fKey,
            autovalidate: isAutoValidate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 50, 0, 0),
                  child: Text(AppLocalizations.of(context).sign_in,
                      style: TextStyle(
                          color: primaryBlue,
                          fontSize: width * 0.1,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: width * 0.05),
                Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Utilities.textField(
                        AppLocalizations.of(context).your_email,
                        false,
                        TextInputAction.done,
                        username,
                        validtor: FieldValidator.validateEmail)),
                SizedBox(height: width * 0.07),
                Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Utilities.textField(
                        AppLocalizations.of(context).password,
                        true,
                        TextInputAction.done,
                        password,
                        validtor: FieldValidator.validatePassword)),
                SizedBox(height: width * 0.05),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        AppNavigator.push(context, const ResetPassword());
                      },
                      child: Text(
                        AppLocalizations.of(context).forgot,
                        style: TextStyle(
                            color: primaryBlue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: width * 0.11),
                Align(
                  alignment: Alignment.centerRight,
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    onPressed: () async {
                      String role = '';
                      if (selected[0]) {
                        role = DatabaseStrings.SCHOOL_COL;
                      } else if (selected[1]) {
                        //
                        //
                        //Teacher
                        role = DatabaseStrings.TEACHER_COL;
                      } else if (selected[2]) {
                        //
                        //
                        //Student
                        role = DatabaseStrings.STUDENT_COL;
                      }
                      print("here we got role ::::::: $role");
                      if (fKey.currentState.validate()) {
                        AuthenticationService service =
                            AuthenticationService(FirebaseAuth.instance);
                        setState(() {
                          isLoading = true;
                        });
                        User user = await service.signIn(
                            role: role,
                            email: username.text,
                            password: password.text);
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        if (user != null) {
                          isLoading = false;
                          prefs.setString('role', role);
                          Fluttertoast.showToast(
                              msg: '$role logged-in!',
                              gravity: ToastGravity.TOP);
                          if (selected[0]) {
                            AppNavigator.makeFirst(
                                context, const AdminDashboard());
                          } else if (selected[1]) {
                            AppNavigator.makeFirst(
                                context, const TeacherDashboard());
                          } else if (selected[2]) {
                            AppNavigator.makeFirst(
                                context, const StudentDashboard());
                          }
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                        }
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
                          AppLocalizations.of(context).sign_in,
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
                selected[2]
                    ? Center(
                        child: RichText(
                          text: TextSpan(
                              text: AppLocalizations.of(context)
                                  .dont_have_account,
                              style: const TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const StudentSignup()));
                                    },
                                  text: AppLocalizations.of(context).signup,
                                  style: TextStyle(
                                    decorationThickness: 2,
                                    fontWeight: FontWeight.bold,
                                    color: primaryBlue,
                                  ),
                                )
                              ]),
                        ),
                      )
                    : selected[0]
                        ? Center(
                            child: RichText(
                              text: TextSpan(
                                  text: AppLocalizations.of(context)
                                      .register_new_school,
                                  style: const TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RegisterSchool()));
                                        },
                                      text: 'Click here',
                                      style: TextStyle(
                                        decorationThickness: 2,
                                        fontWeight: FontWeight.bold,
                                        color: primaryBlue,
                                      ),
                                    )
                                  ]),
                            ),
                          )
                        : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

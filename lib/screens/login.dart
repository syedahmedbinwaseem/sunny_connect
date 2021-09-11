import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sunny_connect/screens/register_school.dart';
import 'package:sunny_connect/screens/student_dashboard.dart';
import 'package:sunny_connect/screens/student_signup.dart';
import 'package:sunny_connect/screens/widgets.dart';
import 'package:sunny_connect/utils/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  List<bool> selected = [false, false, true];
  bool textFieldSelected = false;

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final value = WidgetsBinding.instance!.window.viewInsets.bottom;
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
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
      body: Stack(
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
    );
  }

  Widget topContainer(var height, var width) {
    return Container(
      padding: EdgeInsets.fromLTRB(width * 0.13, height * 0.125, 0, 0),
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                userSelection(
                    !selected[0]
                        ? MediaQuery.of(context).size.height * 0.045
                        : MediaQuery.of(context).size.height * 0.05,
                    !selected[0]
                        ? MediaQuery.of(context).size.width * 0.32
                        : MediaQuery.of(context).size.width * 0.4,
                    "ADMIN", () {
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
                    "TEACHER", () {
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
                    "STUDENT", () {
                  studentSelect();
                }),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 50, 0, 0),
                child: Text('Sign In',
                    style: TextStyle(
                        color: primaryBlue,
                        fontSize: width * 0.1,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: width * 0.05),
              Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Utilities.textField(
                      "Username", false, TextInputAction.done, username)),
              SizedBox(height: width * 0.07),
              Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Utilities.textField(
                      "Password", true, TextInputAction.done, password)),
              SizedBox(height: width * 0.05),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                        color: primaryBlue, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: width * 0.11),
              Align(
                alignment: Alignment.centerRight,
                // ignore: deprecated_member_use
                child: FlatButton(
                  onPressed: onTap,
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
                        'Login',
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
              selected[2]
                  ? Center(
                      child: RichText(
                        text: TextSpan(
                            text: 'Don\'t have an account? ',
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
                                text: 'Sign up',
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
                                text: 'Want to register new school? ',
                                style: const TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const RegisterSchool()));
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
    );
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sunny_connect/screens/login.dart';
import 'package:sunny_connect/screens/widgets.dart';
import 'package:sunny_connect/utils/colors.dart';

class StudentSignup extends StatefulWidget {
  const StudentSignup({Key? key}) : super(key: key);

  @override
  _StudentSignupState createState() => _StudentSignupState();
}

class _StudentSignupState extends State<StudentSignup>
    with WidgetsBindingObserver {
  bool textFieldSelected = false;

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

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
      backgroundColor: primaryBlue,
      appBar: AppBar(
        title: const Text('Student'),
        backgroundColor: primaryBlue,
        elevation: 0,
        centerTitle: true,
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              topContainer(height, width, app),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: bottomContainer(height, width, () {}))
            ],
          ),
        ),
      ),
    );
  }

  Widget topContainer(double height, double width, double app) {
    return SizedBox(
      height: height * 0.37 - app,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: height * 0.12,
              width: height * 0.12,
              child: Image.asset('assets/images/student.png')),
          SizedBox(height: height * 0.03),
          const Text(
            'Create A New Account',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          )
        ],
      ),
    );
  }

  Widget bottomContainer(double height, double width, Function() onTap) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 70, 0, 50),
      height: height * 0.64,
      width: width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(120)),
        color: Colors.white,
      ),
      child: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Utilities.textField(
                    "Email", false, TextInputAction.next, email),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Utilities.textField(
                    "Password", true, TextInputAction.next, password),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Utilities.textField("Confirm password", true,
                    TextInputAction.done, confirmPassword),
              ),
              const SizedBox(height: 30),
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
                        'Sign up',
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
              Center(
                child: RichText(
                  text: TextSpan(
                      text: 'Already have an account? ',
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()));
                            },
                          text: 'Sign in',
                          style: TextStyle(
                            decorationThickness: 2,
                            fontWeight: FontWeight.bold,
                            color: primaryBlue,
                          ),
                        )
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

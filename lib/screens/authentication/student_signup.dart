import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:sunny_connect/screens/authentication/login.dart';
import 'package:sunny_connect/services/auth_service.dart';
import 'package:sunny_connect/utils/app_navigator.dart';
import 'package:sunny_connect/utils/field_validator.dart';
import 'package:sunny_connect/utils/widgets.dart';
import 'package:sunny_connect/utils/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StudentSignup extends StatefulWidget {
  const StudentSignup({Key key}) : super(key: key);

  @override
  _StudentSignupState createState() => _StudentSignupState();
}

class _StudentSignupState extends State<StudentSignup>
    with WidgetsBindingObserver {
  bool textFieldSelected = false;

  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

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
      backgroundColor: primaryBlue,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).student,
        ),
        backgroundColor: primaryBlue,
        elevation: 0,
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: ScrollConfiguration(
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
          Text(
            AppLocalizations.of(context).create_new_account,
            style: const TextStyle(
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
          child: Form(
            key: fKey,
            autovalidate: isAutoValidate,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Utilities.textField(
                      AppLocalizations.of(context).username,
                      false,
                      TextInputAction.next,
                      name,
                      validtor: FieldValidator.validateField),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Utilities.textField(AppLocalizations.of(context).email,
                      false, TextInputAction.next, email,
                      validtor: FieldValidator.validateEmail),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Utilities.textField(
                      AppLocalizations.of(context).password,
                      true,
                      TextInputAction.next,
                      password,
                      validtor: FieldValidator.validatePassword),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Utilities.textField(
                      AppLocalizations.of(context).confirm_password,
                      true,
                      TextInputAction.done,
                      confirmPassword,
                      validtor: (input) => input != password.text
                          ? 'Password doesn\'t match!'
                          : null),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    onPressed: () async {
                      if (fKey.currentState.validate()) {
                        AuthenticationService service =
                            AuthenticationService(FirebaseAuth.instance);
                        setState(() {
                          isLoading = true;
                        });
                        User user = await service.signupStudentWithEmail(
                            email: email.text,
                            password: password.text,
                            name: name.text);

                        if (user != null) {
                          Utilities.showToast(
                              'New Student registered successfully!');
                          await service.signOut();
                          AppNavigator.makeFirst(context, LoginScreen());
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
                          AppLocalizations.of(context).signup,
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
                Center(
                  child: RichText(
                    text: TextSpan(
                        text: AppLocalizations.of(context).dont_have_account,
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()));
                              },
                            text: AppLocalizations.of(context).signin,
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
      ),
    );
  }
}

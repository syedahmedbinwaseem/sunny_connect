import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:sunny_connect/screens/authentication/login.dart';
import 'package:sunny_connect/services/auth_service.dart';
import 'package:sunny_connect/utils/app_navigator.dart';
import 'package:sunny_connect/utils/field_validator.dart';
import 'package:sunny_connect/utils/widgets.dart';
import 'package:sunny_connect/utils/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword>
    with WidgetsBindingObserver {
  bool textFieldSelected = false;

  TextEditingController email = TextEditingController();

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
              child: Icon(Icons.security,
                  size: height * 0.12, color: Colors.white)),
          SizedBox(height: height * 0.03),
          Text(
            AppLocalizations.of(context).reset_password,
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
                SizedBox(height: height * 0.1),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Utilities.textField(
                      "Email", false, TextInputAction.next, email,
                      validtor: FieldValidator.validateEmail),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    onPressed: () async {
                      if (fKey.currentState.validate()) {
                        try {
                          setState(() {
                            isLoading = true;
                          });
                          final FirebaseAuth _firebaseAuth =
                              FirebaseAuth.instance;
                          await _firebaseAuth.sendPasswordResetEmail(
                              email: email.text.toString());
                          await Utilities.showInfoDialog(
                              context,
                              AppLocalizations.of(context)
                                  .reset_link_sent_title,
                              AppLocalizations.of(context).reset_link_text);
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                              (route) => false);
                        } catch (e) {
                          setState(() {
                            isLoading = false;
                          });
                          if (e.code == 'too-many-requests') {
                            Fluttertoast.showToast(
                              msg:
                                  AppLocalizations.of(context).too_many_request,
                            );
                          } else {
                            Fluttertoast.showToast(
                              msg:
                                  AppLocalizations.of(context).operation_failed,
                            );
                          }
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
                          AppLocalizations.of(context).submit,
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
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:sunny_connect/modals/users/current_app_user.dart';
import 'package:sunny_connect/modals/users/teacher.dart';
import 'package:sunny_connect/screens/admin_specific/admin_dashboard.dart';
import 'package:sunny_connect/services/auth_service.dart';
import 'package:sunny_connect/services/database_service.dart';
import 'package:sunny_connect/services/md5_covert.dart';
import 'package:sunny_connect/utils/app_navigator.dart';
import 'package:sunny_connect/utils/colors.dart';
import 'package:sunny_connect/utils/field_validator.dart';
import 'package:sunny_connect/utils/widgets.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangeTeacher extends StatefulWidget {
  const ChangeTeacher({Key key, this.teacher}) : super(key: key);

  final Teacher teacher;

  @override
  _ChangeTeacherState createState() => _ChangeTeacherState();
}

class _ChangeTeacherState extends State<ChangeTeacher> {
  GlobalKey<FormState> fKey = GlobalKey<FormState>();
  bool isAutoValidate = false;
  bool isLoading = false;

  final TextEditingController email = TextEditingController();
  final TextEditingController name = TextEditingController();

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() {
    email.text = widget.teacher.email;
    name.text = widget.teacher.name;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // AuthenticationService.doesEmailExists('abckashifg@gmail.com', FirebaseAuth.instance.app);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Teacher'),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: SingleChildScrollView(
          child: Column(
            children: [
              topContainer(height, width),
              bottomContainer(height, width)
            ],
          ),
        ),
      ),
    );
  }

  Widget topContainer(double height, double width) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.teacher.name,
            style: TextStyle(
                fontSize: 19, color: primaryBlue, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.email_outlined, color: primaryBlue, size: 13),
              const SizedBox(width: 6),
              Text(
                widget.teacher.email,
                style: TextStyle(fontSize: 12, color: primaryBlue),
              ),
            ],
          ),
          Text(
            '${AppLocalizations.of(context).member_since} ${DateFormat('dd MMM, yyyy').format(widget.teacher.joinDate)}',
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(
            height: 5,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.0),
            child: Divider(
              height: 3,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.0),
            child: Divider(
              height: 3,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.0),
            child: Divider(
              height: 3,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.0),
            child: Divider(
              height: 3,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.0),
            child: Divider(
              height: 3,
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomContainer(double height, double width) {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      child: Form(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 7),
              child: Utilities.textField(
                  AppLocalizations.of(context).teacher_name,
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
            Container(
                child: MaterialButton(
              color: primaryBlue,
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                String password =
                    MD5Service.decodeMd5(widget.teacher.changeCode);
                bool res = await AuthenticationService.changeTeacherEmail(
                    context,
                    CurrentAppUser.currentUserData.uid,
                    name.text,
                    widget.teacher.email,
                    email.text,
                    password);
                setState(() {
                  isLoading = false;
                });
                if (res) {
                  Fluttertoast.showToast(msg: 'Teacher Changed!');
                  await Utilities.showInfoDialog(context, 'Teacher Changed',
                      'Invitation email sent to new added teacher email("${email.text}")!');
                  AppNavigator.makeFirst(context, const AdminDashboard());
                }
              },
              child: const Text('      SAVE      ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500)),
            )),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

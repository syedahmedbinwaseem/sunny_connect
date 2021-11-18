import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:sunny_connect/screens/authentication/login.dart';
import 'package:sunny_connect/services/auth_service.dart';
import 'package:sunny_connect/utils/app_navigator.dart';
import 'package:sunny_connect/utils/field_validator.dart';
import 'package:sunny_connect/utils/widgets.dart';
import 'package:sunny_connect/utils/colors.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterSchool extends StatefulWidget {
  // const RegisterSchool({Key? key}) : super(key: key);

  @override
  _RegisterSchoolState createState() => _RegisterSchoolState();
}

class _RegisterSchoolState extends State<RegisterSchool>
    with WidgetsBindingObserver {
  bool textFieldSelected = false;
  GlobalKey<FormState> fKey = GlobalKey<FormState>();
  bool isAutoValidate = false;
  bool isLoading = false;

  final TextEditingController email = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController country = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController password = TextEditingController();

  String initialCountry = 'MA';
  PhoneNumber number = PhoneNumber(isoCode: 'MA');
  String phoneNumber = '';
  @override
  void initState() {
    isLoading = false;
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
    // isLoading = false;
    print("Here we got hone number : ${number.phoneNumber}");
    return Scaffold(
      backgroundColor: primaryBlue,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).school),
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
              child: Image.asset('assets/images/school.png')),
          SizedBox(height: height * 0.03),
          Text(
            AppLocalizations.of(context).register_new_school,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          )
        ],
      ),
    );
  }

  Widget bottomContainer(double height, double width, Function() onTap) {
    // var city;
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 50, 0, 50),
      height: height * 0.65,
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
                  padding: const EdgeInsets.only(right: 20, top: 7),
                  child: Utilities.textField(
                      AppLocalizations.of(context).password,
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
                // Padding(
                //   padding: const EdgeInsets.only(right: 20),
                //   child: Utilities.textField(
                //       "Phone number", false, TextInputAction.next, number, validtor: FieldValidator.validateField, keyboardType: TextInputType.number),
                // ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      print(number.phoneNumber);
                    },
                    onInputValidated: (bool value) {
                      print(value);
                    },
                    selectorConfig: SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    ),
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.disabled,
                    selectorTextStyle: TextStyle(color: Colors.black),
                    initialValue: number,
                    textFieldController: numberController,
                    formatInput: false,
                    keyboardType: TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputBorder: OutlineInputBorder(),
                    hintText: AppLocalizations.of(context).phone_number,
                    onSaved: (PhoneNumber number) {
                      print('On Saved: $number');
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Utilities.textField(AppLocalizations.of(context).city,
                      false, TextInputAction.next, city,
                      validtor: FieldValidator.validateField),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Utilities.textField(
                      AppLocalizations.of(context).country,
                      false,
                      TextInputAction.done,
                      country,
                      validtor: FieldValidator.validateField),
                ),
                const SizedBox(height: 10),
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
                        phoneNumber = number.phoneNumber ?? '';
                        print("Here we are trying to register user");
                        User user = await service.registerSchoolWithEmail(
                            email: email.text,
                            password: password.text,
                            phone: phoneNumber,
                            city: city.text,
                            country: country.text,
                            name: name.text);
                        print("Here we got resposne After signup : $user");
                        if (user != null) {
                          Utilities.showToast(
                              'New School registered successfully!');
                          await service.signOut();
                          AppNavigator.makeFirst(context, const LoginScreen());
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
                          AppLocalizations.of(context).register,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void getPhoneNumber(String phoneNumber) async {
  //   PhoneNumber number =
  //       await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

  //   setState(() {
  //     this.number = number;
  //   });
  // }
}

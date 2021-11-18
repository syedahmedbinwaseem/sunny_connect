import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sunny_connect/modals/users/current_app_user.dart';
import 'package:sunny_connect/services/database_service.dart';
import 'package:sunny_connect/src/constants/database_strings.dart';
import 'package:sunny_connect/utils/colors.dart';
import 'package:sunny_connect/utils/field_validator.dart';
import 'package:sunny_connect/utils/widgets.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({Key key}) : super(key: key);

  @override
  _AdminProfileState createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  GlobalKey<FormState> fKey = GlobalKey<FormState>();
  bool isAutoValidate = false;
  bool isLoading = false;

  final TextEditingController email = TextEditingController();
  final TextEditingController number = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController country = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController description = TextEditingController();

  bool isCamera;
  bool readOnly;
  bool imageLoading;

  final picker = ImagePicker();
  File _image;

  @override
  void initState() {
    imageLoading = false;
    readOnly = true;
    _loadData();
    super.initState();
  }

  void _loadData() {
    email.text = CurrentAppUser.currentUserData.email;
    number.text = CurrentAppUser.currentUserData.phone;
    name.text = CurrentAppUser.currentUserData.name;
    country.text = CurrentAppUser.currentUserData.country;
    city.text = CurrentAppUser.currentUserData.city;
    description.text = CurrentAppUser.currentUserData.aboutMe;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).school),
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
          !readOnly
              ? const SizedBox(height: 10)
              : Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                        onTap: () {
                          setState(() {
                            readOnly = false;
                          });
                        },
                        child: Icon(Icons.edit_outlined, color: primaryBlue)),
                  ),
                ),
          GestureDetector(
            onTap: () {
              _buildBottomSheet(context);
            },
            child: Container(
              height: 120,
              width: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(1000),
                child: CachedNetworkImage(
                  imageUrl: CurrentAppUser
                      .currentUserData.photoUrl, //'${data['photo_url']}'
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(
                    Icons.person,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            CurrentAppUser.currentUserData.name,
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
                CurrentAppUser.currentUserData.email,
                style: TextStyle(fontSize: 12, color: primaryBlue),
              ),
            ],
          ),
          Text(
            '${AppLocalizations.of(context).member_since} ${DateFormat('dd MMM, yyyy').format(CurrentAppUser.currentUserData.createdAt)}',
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
                  AppLocalizations.of(context).school_name,
                  false,
                  TextInputAction.next,
                  name,
                  validtor: FieldValidator.validateField,
                  readOnly: readOnly),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Utilities.textField(AppLocalizations.of(context).email,
                  false, TextInputAction.next, email,
                  validtor: FieldValidator.validateEmail, readOnly: true),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Utilities.textField(
                  AppLocalizations.of(context).phone_number,
                  false,
                  TextInputAction.next,
                  number,
                  validtor: FieldValidator.validateField,
                  readOnly: readOnly,
                  keyboardType: TextInputType.number),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Utilities.textField(AppLocalizations.of(context).city,
                  false, TextInputAction.next, city,
                  validtor: FieldValidator.validateField, readOnly: readOnly),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Utilities.textField(AppLocalizations.of(context).country,
                  false, TextInputAction.done, country,
                  validtor: FieldValidator.validateField, readOnly: readOnly),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Utilities.textField(
                  AppLocalizations.of(context).description,
                  false,
                  TextInputAction.next,
                  description,
                  validtor: FieldValidator.validatePassword,
                  readOnly: readOnly,
                  maxLines: 100),
            ),
            const SizedBox(height: 10),
            readOnly
                ? SizedBox(
                    height: 5,
                  )
                : Container(
                    child: MaterialButton(
                    color: primaryBlue,
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      bool res = await DatabaseServie.updateAdmindata(
                          CurrentAppUser.currentUserData.uid,
                          name.text,
                          number.text,
                          city.text,
                          country.text,
                          description.text);
                      setState(() {
                        isLoading = false;
                      });
                      if (res) {
                        Fluttertoast.showToast(msg: 'Profile Updated!');
                        setState(() {
                          readOnly = true;
                        });
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

  Future getImage() async {
    PickedFile pickedFile;
    if (isCamera) {
      if (await Permission.camera.request().isGranted) {
        pickedFile = await picker.getImage(
          source: isCamera ? ImageSource.camera : ImageSource.gallery,
          maxHeight: 520,
          maxWidth: 520,
          imageQuality: 60,
        );
      }
    } else {
      if (await Permission.storage.request().isGranted) {
        pickedFile = await picker.getImage(
          source: isCamera ? ImageSource.camera : ImageSource.gallery,
          maxHeight: 520,
          maxWidth: 520,
          imageQuality: 60,
        );
      }
    }

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        setState(() {
          imageLoading = true;
        });
        DatabaseServie.updateImage(DatabaseStrings.SCHOOL_COL,
                CurrentAppUser.currentUserData.uid, _image)
            .then((value) {
          setState(() {
            imageLoading = false;
          });
          Fluttertoast.showToast(msg: 'Image updated!');
        });
      } else {
        print('No image selected.');
      }
    });
  }

  Widget _buildBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    setState(() {
                      isCamera = false;
                    });
                    getImage();
                    Navigator.pop(context);
                  },
                  leading: const Icon(
                    Icons.photo_library,
                  ),
                  title: const Text('Photo Library').text.size(15).make(),
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      isCamera = true;
                    });
                    getImage();
                    Navigator.pop(context);
                  },
                  leading: const Icon(
                    Icons.camera_alt,
                  ),
                  title: const Text('Camera').text.size(15).make(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

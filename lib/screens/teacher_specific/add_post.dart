import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sunny_connect/modals/app_class.dart';
import 'package:sunny_connect/modals/app_post.dart';
import 'package:sunny_connect/modals/users/current_app_user.dart';
import 'package:sunny_connect/screens/classroom_feeds.dart';
import 'package:sunny_connect/screens/teacher_specific/start_streaming.dart';
import 'package:sunny_connect/screens/teacher_specific/teacher_dashboard.dart';
import 'package:sunny_connect/screens/teacher_specific/teacher_streaming.dart';
import 'package:sunny_connect/services/NotificationManager/push_notification_manager.dart';
import 'package:sunny_connect/services/database_service.dart';
import 'package:sunny_connect/utils/app_navigator.dart';
import 'package:sunny_connect/utils/field_validator.dart';
import 'package:sunny_connect/utils/widgets.dart';
import 'package:sunny_connect/utils/colors.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key key, @required this.appClass}) : super(key: key);
  final AppClass appClass;

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> with WidgetsBindingObserver {
  TextEditingController description = TextEditingController();

  GlobalKey<FormState> fKey = GlobalKey<FormState>();
  bool isLoading;
  bool isAutoValidate;
  bool isCamera;
  String fileType;

  final picker = ImagePicker();
  File file;
  String _channelName = 'live_video_stream';

  @override
  void initState() {
    isLoading = false;
    isAutoValidate = false;

    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    print("Here we got :: Class Id ; ${widget.appClass.id}");
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.of(context).post_appbar_text),
          actions: [
            IconButton(
                onPressed: () {
                  Utilities.showToast(
                      'Live video streaming feature is comming soon!');
                  // onJoin();
                },
                icon: const Icon(Icons.video_call_rounded)),
          ]),
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
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Center(
                  child: Text(
                AppLocalizations.of(context).post_text,
                textAlign: TextAlign.center,
              )),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Utilities.textField(
                  AppLocalizations.of(context).postfield_labeltext,
                  false,
                  TextInputAction.done,
                  description,
                  validtor: FieldValidator.validateField,
                  maxLines: 7),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        _buildBottomSheet(context);
                      },
                      icon: Icon(Icons.photo, color: primaryBlue)),
                  const SizedBox(width: 10),
                  IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        getFile();
                      },
                      icon: Icon(Icons.attach_file, color: primaryBlue)),
                ],
              ),
            ),
            file == null
                ? const SizedBox(height: 1)
                : (fileType == 'image')
                    ? Container(
                        height: 100,
                        width: width - 50,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(file, fit: BoxFit.cover)),
                      )
                    : Center(child: Text('${file.path} ')),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerRight,
              // ignore: deprecated_member_use
              child: FlatButton(
                onPressed: () async {
                  if (fKey.currentState.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    if (file == null) {
                      bool res = await Post.addNewPost(
                          description.text,
                          CurrentAppUser.currentUserData.uid,
                          widget.appClass.id,
                          '',
                          '',
                          'text',
                          false,
                          '');
                      if (res) {
                        await Utilities.showInfoDialog(
                            context,
                            AppLocalizations.of(context).post_published_title,
                            AppLocalizations.of(context).post_published_text);
                        NotificationManager().sendAndRetrieveMessage(
                            widget.appClass.id,
                            '${CurrentAppUser.currentUserData.name} - ${AppLocalizations.of(context).post_new_announcement_title} : ${widget.appClass.name}',
                            '${CurrentAppUser.currentUserData.name} : ${widget.appClass.name} -- ${description.text}');
                        AppNavigator.pop(context);
                        setState(() {
                          isLoading = false;
                        });
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    } else {
                      String url = await DatabaseServie.uploadFile(
                          CurrentAppUser.currentUserData.uid, file);
                      if (url != null) {
                        String extension_ =
                            file.path.toString().split('.').last.toString();
                        bool res = await Post.addNewPost(
                            description.text,
                            CurrentAppUser.currentUserData.uid,
                            widget.appClass.id,
                            fileType,
                            url,
                            'file',
                            false,
                            extension_.contains('/') ? '' : extension_);
                        if (res) {
                          NotificationManager().sendAndRetrieveMessage(
                              widget.appClass.id,
                              '${CurrentAppUser.currentUserData.name} - ${AppLocalizations.of(context).post_new_announcement_title} : ${widget.appClass.name}',
                              '${CurrentAppUser.currentUserData.name} : ${widget.appClass.name} -- ${description.text} & uploaded a file.');
                          await Utilities.showInfoDialog(
                            context,
                            AppLocalizations.of(context).post_published_title,
                            AppLocalizations.of(context).post_published_text,
                          );
                          AppNavigator.pop(context);
                          setState(() {
                            isLoading = false;
                          });
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
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
                      AppLocalizations.of(context).post,
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
        file = File(pickedFile.path);
        fileType = 'image';
      } else {
        // print('No image selected.');
      }
    });
  }

  getFile() async {
    try {
      if (await Permission.storage.request().isGranted) {
        FilePickerResult result = await FilePicker.platform.pickFiles();

        if (result != null) {
          file = File(result.files.single.path);
          fileType = 'document';
          setState(() {});
        } else {}
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'File not selected!');
    }
  }

  Future<void> onJoin({bool isBroadcaster}) async {
    if ((await Permission.camera.request().isGranted) &&
        (await Permission.microphone.request().isGranted)) {
      AppNavigator.push(context, const TeacherStreaming());
    }
  }
}

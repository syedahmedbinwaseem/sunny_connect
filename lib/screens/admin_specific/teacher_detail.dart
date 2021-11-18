import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sunny_connect/modals/app_class.dart';
import 'package:sunny_connect/modals/users/teacher.dart';
import 'package:sunny_connect/utils/app_navigator.dart';
import 'package:sunny_connect/utils/colors.dart';
import 'package:sunny_connect/utils/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../classroom_feeds.dart';
import 'change_teacher.dart';

class TeacherDetails extends StatefulWidget {
  TeacherDetails({Key key, this.teacher}) : super(key: key);
  Teacher teacher;

  @override
  _TeacherDetailsState createState() => _TeacherDetailsState();
}

class _TeacherDetailsState extends State<TeacherDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).teacher),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _header(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context).classrooms,
                      style: TextStyle(
                          fontSize: 19,
                          color: primaryBlue,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      AppClass.streamAppClassWithTeacher(widget.teacher.uid),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                          child: Text(
                              AppLocalizations.of(context).operation_failed));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(
                              semanticsLabel: "Loading..."));
                    }

                    if (snapshot.data.docs.isEmpty) {
                      return const Center(
                          child: Text("No class found!",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              )));
                    }

                    return Column(
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        return classCard(MediaQuery.of(context).size.height,
                            MediaQuery.of(context).size.width, data);
                      }).toList(),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget classCard(double height, double width, Map<String, dynamic> data) {
    AppClass appClass = AppClass.fromMap(data);
    return GestureDetector(
      onTap: () {
        AppNavigator.push(
            context,
            ClassRoomScreen(
              appClass: appClass,
            ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.all(10),
            // height: width * 0.3,
            width: width,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${appClass.name} ',
                      style: TextStyle(
                          fontSize: 16,
                          color: primaryBlue,
                          fontWeight: FontWeight.bold),
                    ),
                    // const Spacer(),
                    Text(
                      '${DateFormat('dd MMM, yyyy').format(appClass.createdAt)} ',
                      style: TextStyle(
                        fontSize: 12,
                        color: primaryBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '${appClass.description ?? 'No-Description added!'} ',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: SizedBox(
                height: 20,
                child: IconButton(
                  icon: Icon(Icons.change_circle_outlined, color: primaryBlue),
                  onPressed: () async {
                    await Utilities.showInfoDialog(
                        context,
                        'Warning! Change Teacher',
                        "Changing the email of the teacher's account, will make the previous teacher unable to access the teacher's account.");
                    AppNavigator.push(
                        context, ChangeTeacher(teacher: widget.teacher));
                  },
                )),
          ),
          Container(
            height: 120,
            width: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(1000),
              child: CachedNetworkImage(
                imageUrl: widget.teacher.photoUrl, //'${data['photo_url']}'
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => Icon(Icons.person),
                fit: BoxFit.cover,
              ),
            ),
          ),
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
          Text(
            widget.teacher.aboutMe ?? 'No description added!',
            style: TextStyle(fontSize: 12),
          ),
          Text(
            '${AppLocalizations.of(context).member_since} ${DateFormat('dd MMM, yyyy').format(widget.teacher.joinDate)}',
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.email_outlined,
                      color: primaryBlue,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      widget.teacher.email,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              ),
              // Expanded(
              //   flex: 1,
              //   child: Container(),
              // ),
              // Expanded(
              //   flex: 50,
              //   child: Row(
              //     children: [
              //       Icon(Icons.phone_outlined, color: primaryBlue,),
              //       const SizedBox(width: 5),
              //       Text(widget.teacher.phoneNo, style: const TextStyle(fontSize: 11  ),),
              //     ],
              //   ),
              // ),
            ],
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
}

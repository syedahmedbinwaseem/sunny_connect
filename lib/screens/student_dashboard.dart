import 'package:flutter/material.dart';
import 'package:sunny_connect/screens/student_classrooms.dart';
import 'package:sunny_connect/screens/student_home.dart';
import 'package:sunny_connect/utils/colors.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({Key? key}) : super(key: key);

  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: primaryBlue,
      body: Column(
        children: [topContainer(height, width), bottomContainer(height, width)],
      ),
    );
  }

  Widget topContainer(double height, double width) {
    return SizedBox(
      height: height * 0.3,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: height * 0.3 / 4,
            backgroundColor: Colors.white,
          ),
          const SizedBox(height: 15),
          const Text(
            'Maya Jones',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          )
        ],
      ),
    );
  }

  Widget bottomContainer(double height, double width) {
    return Container(
      height: height * 0.7,
      width: width,
      color: Colors.white,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.bold),
              labelColor: primaryBlue,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: MaterialIndicator(
                color: primaryBlue,
                paintingStyle: PaintingStyle.fill,
              ),
              indicatorWeight: 2,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(
                  text: 'HOME',
                ),
                Tab(
                  text: 'CLASSROOMS',
                ),
              ],
            ),
            const Expanded(
                child: TabBarView(
              children: [StudentHome(), StudentClassrooms()],
            ))
          ],
        ),
      ),
    );
  }
}

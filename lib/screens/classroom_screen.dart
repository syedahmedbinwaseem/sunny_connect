import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sunny_connect/screens/widgets.dart';
import 'package:sunny_connect/utils/colors.dart';

class ClassRoomScreen extends StatefulWidget {
  const ClassRoomScreen({Key? key}) : super(key: key);

  @override
  _ClassRoomScreenState createState() => _ClassRoomScreenState();
}

class _ClassRoomScreenState extends State<ClassRoomScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Geography C'),
        backgroundColor: primaryBlue,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'POSTS',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                      fontSize: 17),
                ),
                const SizedBox(height: 25),
                topCard(height, width, "Geography C", "07:05 pm", "Description",
                    "July 3, 2021"),
                const SizedBox(height: 20),
                topCard(height, width, "Geography C", "07:05 pm", "Description",
                    "July 3, 2021"),
                const SizedBox(height: 20),
                bottomLiveCard(height, width, "Geography C"),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget topCard(double height, double width, String name, String time,
      String description, String date) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(20),
        // height: width * 0.3,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  name,
                  style: TextStyle(
                      fontSize: 16,
                      color: primaryBlue,
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: primaryBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  description,
                  style: TextStyle(
                      fontSize: 12,
                      color: primaryBlue,
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: primaryBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5), color: primaryBlue),
                height: width * 0.07,
                width: width * 0.26,
                child: const Center(
                  child: Text('Download',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget bottomLiveCard(double height, double width, String name) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(15)),
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                  fontSize: 16,
                  color: primaryBlue,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              'LIVE',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
            const SizedBox(height: 5),
            Container(
              height: width * 0.5,
              width: width,
              decoration: BoxDecoration(border: Border.all(color: Colors.red)),
            )
          ],
        ),
      ),
    );
  }
}

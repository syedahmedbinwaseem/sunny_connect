import 'package:flutter/material.dart';
import 'package:sunny_connect/screens/classroom_screen.dart';
import 'package:sunny_connect/screens/widgets.dart';
import 'package:sunny_connect/utils/colors.dart';

class StudentClassrooms extends StatefulWidget {
  const StudentClassrooms({Key? key}) : super(key: key);

  @override
  _StudentClassroomsState createState() => _StudentClassroomsState();
}

class _StudentClassroomsState extends State<StudentClassrooms> {
  List expanded = [false, false, false, false];
  final TextEditingController name = TextEditingController();
  final TextEditingController code = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // ignore: deprecated_member_use
            FlatButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return addClassRoom(height, width);
                    });
              },
              padding: const EdgeInsets.all(0),
              color: primaryBlue,
              focusColor: primaryBlue,
              highlightColor: primaryBlue.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                height: width * 0.15,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_circle, color: Colors.white),
                    SizedBox(width: 15),
                    Text('Add Your Classroom',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white))
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        classroomCard(height, width, index, "Geography C",
                            "Dean Phillip Jackson"),
                        const SizedBox(height: 25),
                      ],
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget classroomCard(double height, double width, int index, String className,
      String teacherName) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ClassRoomScreen()));
      },
      child: ExpansionPanelList(
        elevation: 2,
        dividerColor: primaryBlue,
        expansionCallback: (item, status) {
          setState(() {
            expanded[index] = !expanded[index];
          });
        },
        animationDuration: const Duration(milliseconds: 300),
        children: [
          ExpansionPanel(
            backgroundColor: Colors.grey.shade50,
            isExpanded: expanded[index],
            headerBuilder: (context, isExpanded) {
              return Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    className,
                    style: TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              );
            },
            body: Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Text(teacherName),
            ),
          ),
        ],
      ),
    );
  }

  Widget addClassRoom(double height, double width) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        height: width * 0.9,
        width: width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Text(
              'Add Classroom',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                  fontSize: 16),
            ),
            const SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Utilities.textField(
                    "Class name", false, TextInputAction.next, name)),
            const SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Utilities.textField(
                    "Class code", false, TextInputAction.next, name)),
            const SizedBox(height: 40),
            // ignore: deprecated_member_use
            FlatButton(
              onPressed: () {},
              padding: const EdgeInsets.all(0),
              color: primaryBlue,
              focusColor: Colors.blue,
              highlightColor: Colors.blue.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(width * 0.13 / 2)),
              child: SizedBox(
                height: width * 0.13,
                width: width * 0.4,
                child: const Center(
                  child: Text(
                    'Add',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

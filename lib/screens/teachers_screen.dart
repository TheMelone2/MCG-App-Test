import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mcgapp/screens/teachers_details_screen.dart';
import 'package:mcgapp/widgets/app_bar.dart';
import 'package:mcgapp/widgets/drawer.dart';

import '../classes/teacher.dart';
import '../widgets/search_bar.dart';

class TeachersPage extends StatefulWidget {
  const TeachersPage({Key? key}) : super(key: key);

  @override
  State<TeachersPage> createState() => _TeachersPageState();
}

class _TeachersPageState extends State<TeachersPage> {
  /*
  final List<String> teachers = <String>[
    "Herr Möller",
    "Herr Sydow",
    "Frau Gatz"
  ];
  */
  final List<Teacher> _teachers = [];

  Future<void> loadJsonData() async {
    var jsonText = await rootBundle.loadString("assets/teachers.json");
    setState(() {
      List data = json.decode(jsonText)['teachers'];
      for (int i = 0; i < data.length; i++) {
        _teachers.add(Teacher.fromJson(data, i));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: MCGAppBar(
          title: "Lehrerliste",
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                List<String> entries = [];
                for (int i = 0; i < _teachers.length; i++) {
                  entries.add("${_teachers[i].anrede} ${_teachers[i].nachname}");
                }
                showSearch(
                  context: context,
                  delegate: MySearchDelegate(searchResults: entries),
                );
              },
            ),
          ],
        ),
        drawer: const MCGDrawer(),
        body: _teachers.isNotEmpty
            ? ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _teachers.length * 2,
              itemBuilder: (BuildContext context, int index) {
                if (index.isOdd) {
                  return const Divider();
                }
                return ListTile(
                  /*leading: CircleAvatar(

                  ),*/
                  title: Text("${_teachers[index ~/ 2].anrede} ${_teachers[index ~/ 2].nachname}"),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) {
                        return TeacherDetails(teacher: _teachers[index ~/ 2]);
                      })
                    );
                  },
                );
              })
          : const Center(child: Text("empty"))
      ),
    );
  }
}
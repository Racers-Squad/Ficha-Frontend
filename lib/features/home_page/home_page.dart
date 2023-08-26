import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../../data/course.dart';
import '../../services/const.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Course> course = [];
  bool isLoading = true;

  void getAllCources() async {
    final response = await http
        .get(Uri.parse('http://${Const.ipurl}:8080/api/currencies/courses'));
    final jsonData = json.decode(response.body);
    for (final cr in jsonData) {
      setState(() {
        course.add(Course.fromJson(cr));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getAllCources();
    const duration = Duration(milliseconds: 300);
    Timer(duration, () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      DataTable(
                        columns: const <DataColumn>[
                          DataColumn(label: Text('Код валюты')),
                          DataColumn(label: Text('Курс')),
                        ],
                        rows: course
                            .map(
                              (course) => DataRow(cells: [
                                DataCell(Text(course.short_name)),
                                DataCell(Text(course.course.toString())),
                              ]),
                            )
                            .toList(),
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

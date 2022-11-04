import 'package:flutter/material.dart';

class Reports extends StatefulWidget {
  String? title;
  Reports({super.key, required this.title});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title!)),
      body: Container(),
    );
  }
}

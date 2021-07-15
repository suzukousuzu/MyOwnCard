import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {

  TestScreen({required this.isMemorizedWords});
  final bool isMemorizedWords;
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

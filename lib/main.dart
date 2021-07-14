import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'私だけの単語帳',
      theme:ThemeData(
        brightness: Brightness.dark,
        fontFamily: "lanobe"
      ),
      home:HomeScreen(),
    );
  }
}

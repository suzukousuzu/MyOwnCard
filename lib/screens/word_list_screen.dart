import 'package:flutter/material.dart';
import 'edit_screen.dart';

class WordListScreen extends StatefulWidget {
  @override
  _WordListScreenState createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('単語一覧',style: TextStyle(fontSize: 20.0),),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return EditScreen();
        })),
        child: Icon(Icons.add),
        tooltip: '新しい単語の登録',
      ),

    );
  }
}

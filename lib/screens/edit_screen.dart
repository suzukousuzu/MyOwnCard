import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moor/ffi.dart';
import 'package:my_own_cards/db/database.dart';
import 'package:my_own_cards/screens/word_list_screen.dart';
import 'package:my_own_cards/main.dart';

enum EditStatus { ADD, EDIT }

class EditScreen extends StatefulWidget {
  EditScreen({required this.state, this.word});

  final EditStatus state;
  final Word? word;

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  var questionController = TextEditingController();
  var answerController = TextEditingController();

  String _titleText = "";
  bool _isQuestion = true;

  @override
  void initState() {
    if (widget.state == EditStatus.EDIT) {
      _titleText = "登録した単語の修正";
      questionController.text = widget.word!.strQuestion;
      answerController.text = widget.word!.strAnswer;
      _isQuestion = false;
    } else {
      _titleText = "新しい単語の登録";
      questionController.text = "";
      answerController.text = "";
      _isQuestion = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return _backToWordScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titleText),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () => _insertWords(),
              icon: Icon(Icons.done),
              tooltip: '登録',
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              height: 30.0,
            ),
            Center(
              child: Text(
                '問題と答えを入力して、「登録」ボタンを押してください',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            //問題入力部分
            _questionInputPart(),
            //答え入力部分
            _answerInputPart(),
          ],
        ),
      ),
    );
  }

  Widget _questionInputPart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          Text(
            '問題',
            style: TextStyle(fontSize: 24.0),
          ),
          SizedBox(
            height: 15.0,
          ),
          TextField(
            enabled: _isQuestion,
            controller: questionController,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
            ),
          )
        ],
      ),
    );
  }

  Widget _answerInputPart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          Text(
            '答え',
            style: TextStyle(fontSize: 24.0),
          ),
          SizedBox(
            height: 15.0,
          ),
          TextField(
            controller: answerController,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
            ),
          )
        ],
      ),
    );
  }

  Future<bool> _backToWordScreen() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return WordListScreen();
    }));
    return Future.value(false);
  }

  _insertWords() async {
    if (questionController.text == '' || answerController.text == '') {
      //エラーメッセージ
      Fluttertoast.showToast(
          msg: '登録に失敗しました',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP);
      return;
    } else {
      var word = Word(
          strQuestion: questionController.text,
          strAnswer: answerController.text);

      try {
        if (widget.state == EditStatus.EDIT) {
          await mydatabase.updateWord(word);
        } else {
          await mydatabase.addWord(word);
        }
        questionController.clear();
        answerController.clear();

        //登録完了メッセージ
        Fluttertoast.showToast(
            msg: '登録が完了しました',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM);
      } on SqliteException catch (e) {
        Fluttertoast.showToast(
            msg: 'この問題はすでに登録されています',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM);
      }
    }
  }
}

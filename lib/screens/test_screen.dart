import 'package:flutter/material.dart';
import 'package:my_own_cards/db/database.dart';
import 'package:my_own_cards/main.dart';
import 'package:my_own_cards/db/database.dart';
import 'package:my_own_cards/screens/home_screen.dart';

enum TestStatus { BEFFORE_START, SHOW_QUESTION, SHOW_ANSWER, FINISHED }

class TestScreen extends StatefulWidget {
  TestScreen({required this.isMemorized});

  final bool isMemorized;

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int _numberOfQuestion = 0;
  String _txtQuestion = '';
  String _txtAnswer = '';
  bool _isMemorized = false;
  bool _isDisplayQuestion = false;
  bool _isDisplayAmswer = false;
  bool _isDisplayCheckBox = false;
  bool _isDisplayFAB = false;
  int _index = 0;
  late Word currentWord;

  List<Word> tstDataList = [];

  TestStatus _testStatus = TestStatus.BEFFORE_START;

  @override
  void initState() {
    super.initState();
    _getTestData();
  }

  void _getTestData() async {
    if (widget.isMemorized) {
      tstDataList = await mydatabase.allWords;
    } else {
      tstDataList = await mydatabase.getMemorizedWords;
    }
    tstDataList.shuffle();
    _testStatus = TestStatus.BEFFORE_START;
    _index = 0;
    setState(() {
      _isDisplayQuestion = false;
      _isDisplayAmswer = false;
      _isDisplayCheckBox = false;
      _isDisplayFAB = true;
      _numberOfQuestion = tstDataList.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _finishTopScreen(),
      child: Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text('確認テスト'),
            ),
          ),
          floatingActionButton: _isDisplayFAB
              ? FloatingActionButton(
                  onPressed: () => _goNextStatus(),
                  child: Icon(Icons.skip_next),
                  tooltip: '次に進む',
                )
              : null,
          body: Stack(children: [
            Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                _numberOfQuestionPart(),
                SizedBox(
                  height: 10.0,
                ),
                _questionCardPart(),
                SizedBox(
                  height: 10.0,
                ),
                _answerCardPart(),
                SizedBox(
                  height: 10.0,
                ),
                _memorizedCheckPart()
              ],
            ),
            _endMessage()
          ])),
    );
  }

  Widget _numberOfQuestionPart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '残り問題数',
          style: TextStyle(fontSize: 15.0),
        ),
        SizedBox(
          width: 12.0,
        ),
        Text(
          _numberOfQuestion.toString(),
          style: TextStyle(fontSize: 23.0),
        )
      ],
    );
  }

  Widget _questionCardPart() {
    if (_isDisplayQuestion == true) {
      return Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Image.asset('assets/images/image_flash_question.png'),
          Text(
            _txtQuestion,
            style: TextStyle(fontSize: 45.0, color: Colors.black),
          )
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _answerCardPart() {
    if (_isDisplayAmswer) {
      return Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Image.asset('assets/images/image_flash_answer.png'),
          Text(
            _txtAnswer,
            style: TextStyle(fontSize: 45.0, color: Colors.black),
          )
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _memorizedCheckPart() {
    if (_isDisplayCheckBox) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: CheckboxListTile(
            title: Text(
              '暗記済みにする場合はチェックを入れてください',
              style: TextStyle(fontSize: 12.0),
            ),
            value: _isMemorized,
            onChanged: (value) {
              setState(() {
                _isMemorized = !_isMemorized;
              });
            }),
      );
    } else {
      return Container();
    }
  }

  Widget _endMessage() {
    if (_testStatus == TestStatus.FINISHED) {
      return Center(
        child: Text(
          'テスト終 了',
          style: TextStyle(fontSize: 50.0),
        ),
      );
    } else {
      return Container();
    }
  }

  _goNextStatus() async {
    switch (_testStatus) {
      case TestStatus.BEFFORE_START:
        _testStatus = TestStatus.SHOW_QUESTION;
        _showQuestion();
        break;

      case TestStatus.SHOW_QUESTION:
        _testStatus = TestStatus.SHOW_ANSWER;
        _showAnswer();
        break;

      case TestStatus.SHOW_ANSWER:
        await _updateMemorizedFlg();
        if (_numberOfQuestion == 0) {
          _testStatus = TestStatus.FINISHED;
          _isDisplayFAB = false;
          setState(() {});
        } else {
          _testStatus = TestStatus.SHOW_QUESTION;
          _showQuestion();
        }
        break;
    }
  }

  void _showQuestion() {
    currentWord = tstDataList[_index];
    setState(() {
      _isDisplayQuestion = true;
      _isDisplayAmswer = false;
      _isDisplayCheckBox = false;
      _isDisplayFAB = true;
      _txtQuestion = currentWord.strQuestion;
      _numberOfQuestion--;
      _index++;
    });
  }

  void _showAnswer() {
    setState(() {
      _isDisplayQuestion = true;
      _isDisplayAmswer = true;
      _isDisplayCheckBox = true;
      _isDisplayFAB = true;
      _txtAnswer = currentWord.strAnswer;
      _isMemorized = currentWord.isMemorized;
    });
  }

  Future<void> _updateMemorizedFlg() async {
    var _updateWord = Word(
        strQuestion: currentWord.strQuestion,
        strAnswer: currentWord.strAnswer,
        isMemorized: _isMemorized);
    await mydatabase.updateWord(_updateWord);
    print(_updateWord);
  }

  Future<bool> _finishTopScreen() async{
     return await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("テスト終了"),
              content: Text("テストを終了してもいいですか"),
              actions: [
                TextButton(
                  child: Text("はい"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text("いいで"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            )) ?? false;
  }
}

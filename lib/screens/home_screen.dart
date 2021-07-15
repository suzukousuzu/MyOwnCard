import 'package:flutter/material.dart';
import 'package:my_own_cards/parts/button_with_icon.dart';
import 'word_list_screen.dart';
import 'test_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isMemorizedWords = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: Image.asset('assets/images/image_title.png')),
            _titleText(),
            Divider(
              color: Colors.white,
              height: 30.0,
              indent: 8.0,
              endIndent: 8.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ButtonWithIcon(
                    color: Colors.cyan,
                    onPressed: () {
                      //押した時の処理
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return TestScreen(isMemorizedWords: isMemorizedWords,);
                      }));
                    },
                    icon: Icon(Icons.play_arrow),
                    label: '確認テストをする'),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            // ラジオぼたん
            _radioButtons(),
            SizedBox(
              height: 30.0,
            ),
            // 単語一覧閲覧ボタン
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ButtonWithIcon(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return WordListScreen();
                    }));
                  },
                  icon: Icon(Icons.list),
                  label: '単語一覧をみる',
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Text(
              'powerded by cossy 2021',
              style: TextStyle(fontFamily: 'Montserrat'),
            )
          ],
        ),
      ),
    );
  }

  Widget _titleText() {
    return Column(
      children: [
        Text(
          "私だけの単語帳",
          style: TextStyle(fontSize: 40.0),
        ),
        Text(
          "MyOwnCard",
          style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
        ),
      ],
    );
  }

  Widget _radioButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 50.0),
      child: Column(
        children: [
          RadioListTile(
              title: Text(
                '暗記済みの単語を除外する',
                style: TextStyle(fontSize: 16.0),
              ),
              value: false,
              groupValue: isMemorizedWords,
              onChanged: (value) {
                setState(() {
                  isMemorizedWords = false;
                });
              }),
          RadioListTile(
              title: Text('暗記済みの単語を含む', style: TextStyle(fontSize: 16.0)),
              value: true,
              groupValue: isMemorizedWords,
              onChanged: (value) {
                setState(() {
                  isMemorizedWords = true;
                });
              })
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:my_own_cards/parts/button_with_icon.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                      //TODO 押した時の処理
                      print('押してあで');
                    },
                    icon: Icon(Icons.play_arrow),
                    label: '確認テストをする'),
              ),
            ),
            //TODO ラジオぼたん
            // 単語一覧閲覧ボタン
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ButtonWithIcon(
                  onPressed: () {
                    print('押したで2');
                  },
                  icon: Icon(Icons.list),
                  label: '単語一覧をみる',
                  color: Colors.grey,
                ),
              ),
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
}

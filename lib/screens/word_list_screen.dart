import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_own_cards/db/database.dart';
import 'package:my_own_cards/main.dart';
import 'edit_screen.dart';

class WordListScreen extends StatefulWidget {
  @override
  _WordListScreenState createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  List<Word> _wordList = [];

  @override
  void initState() {
    getAllWords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '単語一覧',
          style: TextStyle(fontSize: 20.0),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            tooltip: "新しい単語の登録",
            onPressed: () => _sortWord(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return EditScreen(
            state: EditStatus.ADD,
          );
        })),
        child: Icon(Icons.add),
        tooltip: '新しい単語の登録',
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _wordListWidget(),
      ),
    );
  }

  void getAllWords() async {
    _wordList = await mydatabase.allWords;
    setState(() {});
  }

  Widget _wordListWidget() {
    return ListView.builder(
        itemCount: _wordList.length,
        itemBuilder: (context, int position) => _wordItem(position));
  }

  Widget _wordItem(int position) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: ListTile(
        title: Text("${_wordList[position].strQuestion}"),
        subtitle: Text(
          "${_wordList[position].strAnswer}",
          style: TextStyle(fontFamily: 'Montserrat'),
        ),
        trailing: _wordList[position].isMemorized ? Icon(Icons.check) : null,
        onTap: () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return EditScreen(
            state: EditStatus.EDIT,
            word: _wordList[position],
          );
        })),
        onLongPress: () => _deleteWord(_wordList[position]),
      ),
    );
  }

  _deleteWord(Word selectedWord) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
              title: Text(selectedWord.strQuestion),
              content: Text('削除してもいいですか'),
              actions: [
                TextButton(
                    onPressed: () async {
                      await mydatabase.deleteWord(selectedWord);
                      Fluttertoast.showToast(
                          msg: '削除しました',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM);
                      getAllWords();
                      Navigator.pop(context);
                    },
                    child: Text('はい')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('いいえ'))
              ],
            ));
  }

  void _sortWord() async {
    _wordList = await mydatabase.getWordsSorted;
    setState(() {});
  }
}

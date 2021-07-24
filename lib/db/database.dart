import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class Words extends Table {
  TextColumn get strQuestion => text()();

  TextColumn get strAnswer => text()();

  BoolColumn get isMemorized => boolean().withDefault(Constant(false))();

  @override
  Set<Column> get primaryKey => {strQuestion};
}

@UseMoor(tables: [Words])
class Mydatabase extends _$Mydatabase {
  Mydatabase() : super(_openConnection());

  @override
  // TODO: implement schemaVersion
  int get schemaVersion => 3;

  //統合処理
  MigrationStrategy get migration =>
      MigrationStrategy(onCreate: (Migrator m) {
        return m.createAll();
      }, onUpgrade: (Migrator m, int from, int to) async {
        if (from == 2) {
          await m.addColumn(words, words.isMemorized);
        }
      });

  //create
  Future addWord(Word word) => into(words).insert(word);

  //read
  Future<List<Word>> get allWords => select(words).get();

  //Read　暗記済みの単語除外
  Future<List<Word>> get getMemorizedWords =>
      (select(words)
        ..where((tbl) => tbl.isMemorized.equals(false))).get();

  //read ソート
  Future<List<Word>> get getWordsSorted =>
      (select(words)
        ..orderBy([(tbl) => OrderingTerm(expression:tbl.isMemorized )])).get();

  //update
  Future updateWord(Word word) => update(words).replace(word);

  //delete
  Future deleteWord(Word word) =>
      (delete(words)
        ..where((t) => t.strQuestion.equals(word.strQuestion)))
          .go();
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'words.db'));
    return VmDatabase(file);
  });
}

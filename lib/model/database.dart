import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

class DB {
  static Database _userDatabase;

  static Future<Database> getUserDatabase(String dbname) async {
    if (_userDatabase != null) {
      return _userDatabase;
    }
    String dbPath = await sql.getDatabasesPath();
    _userDatabase = await sql.openDatabase(path.join(dbPath, '$dbname.db'),
        onCreate: (db, version) => db.execute(
            'CREATE TABLE users (id TEXT PRIMARY KEY, jsonData TEXT, date INTEGER)'),
        version: 1);
    return _userDatabase;
  }

  static Future<dynamic> searchElements(DateTime from, DateTime to) async {
    await getUserDatabase('UserDetails');
    print('searching user');
    return await _userDatabase.query('users',
        where: 'date>=? AND date<=?',
        whereArgs: [from.microsecondsSinceEpoch, to.microsecondsSinceEpoch]);
  }

  static Future<dynamic> getElements() async {
    await getUserDatabase('UserDetails');
    print('searching user');
    return await _userDatabase.query('users');
  }
  static void insertUserDate(String jsonData, DateTime d) async {
    print('inserting user');
    await getUserDatabase('elementDetails');
    _userDatabase.insert('users', {
      'id': DateTime.now().toString(),
      'jsonData': jsonData,
      'date': d.microsecondsSinceEpoch
    });
  }
}

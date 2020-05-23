import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phonebook/models/contact.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  String tblContact = "Contact";
  String colId = "Id";
  String colName = "Name";
  String colPhoneNumber = "PhoneNumber";
  String colAvatar = "Avatar";

  static final DbHelper _dbHelper = DbHelper._internal();

  DbHelper._internal(); // Static olarak kullanılabilecek demek

  factory DbHelper() => _dbHelper;

  static Database _db; // Sqflite çağırdık

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    Directory dbFolder = await getApplicationDocumentsDirectory();
    String path = join(dbFolder.path, "$tblContact.db");
    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    return await db.execute(
        "CREATE TABLE $tblContact ($colId INTEGER PRIMARY KEY,$colName TEXT,$colPhoneNumber TEXT,$colAvatar TEXT)");
  }

  Future<List<Contact>> getListContact() async {
    var dbClient = await db;
    var result = await dbClient.query("$tblContact", orderBy: "$colName");
    return result.map((data) => Contact.fromMap(data)).toList();
  }

  Future<int> contactAdd(Contact contact) async {
    var dbClient = await db;
    return await dbClient.insert("$tblContact", contact.toMap());
  }

  Future<int> contactUpdate(Contact contact) async {
    var dbClient = await db;
    return await dbClient.update("$tblContact", contact.toMap(),
        where: "$colId=?", whereArgs: [contact.id]);
  }

  Future<void> contactDelete(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete("$tblContact", where: "$colId=?", whereArgs: [id]);
  }
}

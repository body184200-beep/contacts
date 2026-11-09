import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import '../models/contact_model.dart';

class DataBase {
  final String _createTable =
      '''create table $tableContacts(
      $columnId integer primary key autoincrement,
      $columnName text not null,
      $columnEmail text,
      $columnMobile text not null,
      $columnAddress text,
      $columnCompany text,
      $columnWebsite text,
      $columnDesignation text,
      $columnImage text,
      $columnIsFavorite integer default 0
      )''';

  Future<Database> _openDB() async {
    final rootPath = await getDatabasesPath();
    final dbPath = p.join(rootPath, 'contacts.db');
    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        db.execute(_createTable);
      },
    );
  }

  Future<int> insert(ContactModel contactModel) async {
    final db = await _openDB();
    return db.insert(tableContacts, contactModel.toMap());
  }

  Future<List<ContactModel>> getAllContacts() async {
    final db = await _openDB();
    final result = await db.query(tableContacts);
    return result.map((e) => ContactModel.fromMap(e)).toList();
  }

  Future<void> update(ContactModel contact) async {
    final db = await _openDB();
    await db.update(
      tableContacts,
      contact.toMap(),
      where: '$columnId = ?',
      whereArgs: [contact.id],
    );
  }
}

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import '../models/contact_model.dart';

class DataBase {
  final String _createTable =
      '''
    CREATE TABLE $tableContacts (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnName TEXT NOT NULL,
      $columnEmail TEXT,
      $columnMobile TEXT NOT NULL,
      $columnAddress TEXT,
      $columnCompany TEXT,
      $columnWebsite TEXT,
      $columnDesignation TEXT,
      $columnImage TEXT,
      $columnIsFavorite INTEGER DEFAULT 0
    )
  ''';

  Future<Database> _openDB() async {
    final rootPath = await getDatabasesPath();
    final dbPath = p.join(rootPath, 'contacts.db');

    return openDatabase(
      dbPath,
      version: 2,
      onCreate: (db, version) async {
        await db.execute(_createTable);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE $tableContacts ADD COLUMN $columnIsFavorite INTEGER DEFAULT 0',
          );
        }
      },
    );
  }

  // Insert Contact
  Future<int> insert(ContactModel contactModel) async {
    final db = await _openDB();

    return await db.insert(tableContacts, contactModel.toMap());
  }

  // Get All Contacts
  Future<List<ContactModel>> getAllContacts() async {
    final db = await _openDB();

    final result = await db.query(tableContacts);

    return result.map((e) => ContactModel.fromMap(e)).toList();
  }

  // Get Favorite Contacts
  Future<List<ContactModel>> getFavoriteContacts() async {
    final db = await _openDB();

    final result = await db.query(
      tableContacts,
      where: '$columnIsFavorite = ?',
      whereArgs: [1],
    );

    return result.map((e) => ContactModel.fromMap(e)).toList();
  }

  // Get Contact By ID
  Future<ContactModel?> getContactById(int id) async {
    final db = await _openDB();

    final result = await db.query(
      tableContacts,
      where: '$columnId = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) return null;

    return ContactModel.fromMap(result.first);
  }

  // Update Contact
  Future<int> update(ContactModel contact) async {
    final db = await _openDB();

    return await db.update(
      tableContacts,
      contact.toMap(),
      where: '$columnId = ?',
      whereArgs: [contact.id],
    );
  }

  // Delete Contact
  Future<int> delete(int id) async {
    final db = await _openDB();

    return await db.delete(
      tableContacts,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}

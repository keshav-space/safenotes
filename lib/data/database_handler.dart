// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Project imports:
import 'package:safenotes/models/safenote.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();

  static Database? _database;

  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('._my_system_note');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';

    await db.execute('''
  CREATE TABLE $tableNotes ( 
  ${NoteFields.id} $idType, 
  ${NoteFields.title} $textType,
  ${NoteFields.description} $textType,
  ${NoteFields.time} $textType
  )
  ''');
  }

  Future<SafeNote> encryptAndStore(SafeNote note) async {
    final db = await instance.database;
    final id = await db.insert(tableNotes, note.toJsonAndEncrypted());
    return note.copy(id: id);
  }

  Future<SafeNote> decryptReadNote(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableNotes,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return SafeNote.fromJsonAndDecrypt(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<SafeNote>> decryptReadAllNotes() async {
    final db = await instance.database;
    final orderBy = '${NoteFields.time} ASC';
    final result = await db.query(tableNotes, orderBy: orderBy);
    return result.map((json) => SafeNote.fromJsonAndDecrypt(json)).toList();
  }

  Future<String> exportAllEncrypted() async {
    final db = await instance.database;
    final orderBy = '${NoteFields.time} ASC';
    final result = await db.query(tableNotes,
        columns: ['title', 'description', 'time'], orderBy: orderBy);

    return jsonEncode(result).toString();
  }

  Future<int> encryptAndUpdate(SafeNote note) async {
    final db = await instance.database;
    return db.update(
      tableNotes,
      note.toJsonAndEncrypted(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableNotes,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

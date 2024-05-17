import 'package:note_app/constants/note_fields.dart';
import 'package:note_app/model/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NDatabase {
  static final instance = NDatabase._internal();

  static Database? _database;

  NDatabase._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database ??= await _initDatabase('note.db');
    return _database!;
  }

  static Future<Database> _initDatabase(String filePath) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, filePath);

    return await openDatabase(path, version: 1, onCreate: createDatabase);
  }

 static Future<void> createDatabase(Database noteDb, _) async {
    return await noteDb.execute('''
       CREATE TABLE ${NoteFields.tableName}(
        ${NoteFields.id} ${NoteFields.idType},
        ${NoteFields.number} ${NoteFields.intType},
        ${NoteFields.title} ${NoteFields.textType},
        ${NoteFields.content} ${NoteFields.textType},
        ${NoteFields.isFavorite} ${NoteFields.intType},
        ${NoteFields.createdTime} ${NoteFields.textType},
        ${NoteFields.isDeleted} ${NoteFields.intType},
       )
      ''');
  }

  Future<NoteModel> create(NoteModel note) async {
    final db = await instance.database;
    final int id = await db.insert(
      NoteFields.tableName,
      note.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return note.copy(id: id);
  }

  Future<NoteModel> read(int id) async {
    final db = await instance.database;
    final items = await db.query(
      NoteFields.tableName,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );

    if (items.isNotEmpty) {
      return NoteModel.fromJson(items.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<NoteModel>> readAll() async {
    final db = await instance.database;
    final maps = await db.query(NoteFields.tableName);
    return maps.map((json) => NoteModel.fromJson(json)).toList();
  }

  Future<int> update(NoteModel note) async {
    final db = await instance.database;
    return await db.update(
      NoteFields.tableName,
      note.toJson(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(NoteFields.tableName,
        where: '${NoteFields.tableName} = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

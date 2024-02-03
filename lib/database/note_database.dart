import 'package:note_app/constants/note_fields.dart';
import 'package:note_app/model/note_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class NoteDatabase {
  static final NoteDatabase instance = NoteDatabase._internal();

  static Database? _database;

  NoteDatabase._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase('notes.db');
    return _database!;
  }

  Future<Database> initDatabase(String filePath) async {
    final databasePath = await getDatabasesPath();
    final path = p.join(databasePath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    db.execute('''
        CREATE TABLE ${NoteFields.tableName}(
          ${NoteFields.id} ${NoteFields.idType},
          ${NoteFields.number} ${NoteFields.intType},
          ${NoteFields.title} ${NoteFields.textType},
          ${NoteFields.content} ${NoteFields.textType},
          ${NoteFields.isFavorite} ${NoteFields.textType},
          ${NoteFields.createdTime} ${NoteFields.textType},
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
    final item = await db.query(
      NoteFields.tableName,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );

    if (item.isNotEmpty) {
      return NoteModel.fromJson(item.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<NoteModel>> readAll() async {
    final db = await instance.database;
    final items = await db.query(NoteFields.tableName);

    return items.map((json) => NoteModel.fromJson(json)).toList();
  }

  Future update(NoteModel note) async {
    final db = await instance.database;
    return await db.update(
      NoteFields.tableName,
      note.toJson(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      NoteFields.tableName,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

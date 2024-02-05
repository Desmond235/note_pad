import 'package:note_app/constants/note_fields.dart';
import 'package:note_app/model/note_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NoteDatabase {
  static final NoteDatabase instance = NoteDatabase._internal();

  static Database? _database;

  NoteDatabase._internal();

  Future<Database> get database async {
    if (_database !=null) {
      return _database!;
    } 
     _database ??= await _initDatabase('notes1.db');
      return _database!;
  }

  static Future<Database> _initDatabase(String filePath) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  static Future<void> _createDatabase(Database db, _) async {
    return await db.execute('''
        CREATE TABLE ${NoteFields.tableName} (
          ${NoteFields.id} ${NoteFields.idType},
          ${NoteFields.number} ${NoteFields.intType},
          ${NoteFields.title} ${NoteFields.textType},
          ${NoteFields.content} ${NoteFields.textType},
          ${NoteFields.isFavorite} ${NoteFields.intType},
          ${NoteFields.createdTime} ${NoteFields.textType}
        )
      ''');
  }

  Future<NoteModel> create(NoteModel note) async {
    final db = await instance.database;
    final int id = await db.insert(
      NoteFields.tableName,
      note.toJson(),
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
    const orderBy = '${NoteFields.createdTime} ASC';
    final items = await db.query( NoteFields.tableName, orderBy: orderBy);

    return items.map((json) => NoteModel.fromJson(json)).toList();
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

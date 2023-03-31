import 'dart:developer';
import 'package:login_app/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class SqlFliteService {
  static Database? _database;

  SqlFliteService._();
  static final instance = SqlFliteService._();

  Future<Database?> get db async {
    if(_database != null){
      return _database;
    }
    return _database = await initializeDatabase();
  }

  Future<Database> initializeDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'notes.db');     // it creates a path and db name
    var db = await openDatabase(path,version: 1,onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE notes (id TEXT PRIMARY KEY, title TEXT NOT NULL, description TEXT, isSynced INTEGER NOT NULL)",
    );
  }

  Future<LocalNoteModel> insert(LocalNoteModel localNoteModel) async {
    log('Inside insert method');
    var dbClient = await db;
    final id = await dbClient!.insert('notes', localNoteModel.toMap());
    log(id.toString());
    return localNoteModel;
  }

  Future<List<LocalNoteModel>> getNotesList() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult = await dbClient!.query('notes');
    
    return queryResult.map((e) => LocalNoteModel.fromMap(e)).toList();
  }

  Future<List<LocalNoteModel>> getAsyncNotesList() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult = await dbClient!.query('notes',where: 'isSynced', whereArgs: [1]);

    return queryResult.map((e) => LocalNoteModel.fromMap(e)).toList();
  }

  Future<int> update(LocalNoteModel localNoteModel) async {
    log('inside update method');
    var dbClient = await db;
    return await dbClient!.update('notes', localNoteModel.toMap(), where: 'id = ?', whereArgs: [localNoteModel.id]);
  }

  Future<int> delete(String id) async {
    var dbClient = await db;
    return await dbClient!.delete('notes',where: 'id = ?',whereArgs: [id]);
  }
}
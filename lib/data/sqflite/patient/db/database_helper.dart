import 'package:path/path.dart';
import 'package:project_3_kawsay/data/sqflite/patient/db/database_initializer.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'medical_records.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: DatabaseInitializer.createDatabase,
    );
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}

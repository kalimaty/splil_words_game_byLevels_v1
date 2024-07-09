import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _instance = DatabaseHelper._internal();
  static DatabaseHelper get instance => _instance;

  late Database _database;

  DatabaseHelper._internal();

  Future<void> initializeDatabase() async {
    // Replace 'path_to_your_database.db' with your actual database path
    String path = await getDatabasesPath();
    path = join(path, 'your_database.db');

    // Open or create the database at the specified path
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        // Database schema creation if it doesn't exist
        return db.execute(
          "CREATE TABLE questions(id INTEGER PRIMARY KEY, question TEXT, answer TEXT, a INTEGER, answerOrder INTEGER)",
        );
      },
    );
  }

  // Getter to access the database instance
  Future<Database> get database async {
    if (_database.isOpen) {
      return _database;
    } else {
      await initializeDatabase();
      return _database;
    }
  }
}

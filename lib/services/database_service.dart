import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:fitto/models/nutrition_entry.dart';
import 'package:fitto/models/user.dart';
import 'package:fitto/models/progress_entry.dart';

class DatabaseService {
  static Database? _database;
  static const String _databaseName = 'fitto.db';
  static const int _databaseVersion = 1;

  // Table names
  static const String _nutritionTable = 'nutrition_entries';
  static const String _usersTable = 'users';
  static const String _progressTable = 'progress_entries';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create nutrition entries table
    await db.execute('''
      CREATE TABLE $_nutritionTable (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        date TEXT NOT NULL,
        meal_type TEXT NOT NULL,
        name TEXT NOT NULL,
        calories INTEGER NOT NULL,
        protein REAL NOT NULL,
        carbs REAL NOT NULL,
        fats REAL NOT NULL,
        serving_size TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Create users table
    await db.execute('''
      CREATE TABLE $_usersTable (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        weight REAL NOT NULL,
        height REAL NOT NULL,
        age INTEGER NOT NULL,
        gender TEXT NOT NULL,
        daily_calorie_goal INTEGER NOT NULL,
        daily_water_goal INTEGER NOT NULL,
        daily_steps_goal INTEGER NOT NULL,
        is_premium INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Create progress entries table
    await db.execute('''
      CREATE TABLE $_progressTable (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        date TEXT NOT NULL,
        type TEXT NOT NULL,
        value REAL NOT NULL,
        unit TEXT NOT NULL,
        notes TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Create indexes for better performance
    await db.execute('CREATE INDEX idx_nutrition_user_date ON $_nutritionTable (user_id, date)');
    await db.execute('CREATE INDEX idx_nutrition_meal_type ON $_nutritionTable (meal_type)');
    await db.execute('CREATE INDEX idx_progress_user_date ON $_progressTable (user_id, date)');
    await db.execute('CREATE INDEX idx_progress_type ON $_progressTable (type)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < 2) {
      // Example: Add new columns or tables
    }
  }

  // Nutrition Entries CRUD
  Future<void> insertNutritionEntry(NutritionEntry entry) async {
    final db = await database;
    await db.insert(
      _nutritionTable,
      entry.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<NutritionEntry>> getNutritionEntries(String userId, DateTime? date) async {
    final db = await database;
    String whereClause = 'user_id = ?';
    List<dynamic> whereArgs = [userId];

    if (date != null) {
      final dateStr = date.toIso8601String().split('T')[0];
      whereClause += ' AND date LIKE ?';
      whereArgs.add('$dateStr%');
    }

    final List<Map<String, dynamic>> maps = await db.query(
      _nutritionTable,
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => NutritionEntry.fromJson(map)).toList();
  }

  Future<List<NutritionEntry>> getNutritionEntriesByMealType(
    String userId,
    String mealType,
    DateTime? date,
  ) async {
    final db = await database;
    String whereClause = 'user_id = ? AND meal_type = ?';
    List<dynamic> whereArgs = [userId, mealType];

    if (date != null) {
      final dateStr = date.toIso8601String().split('T')[0];
      whereClause += ' AND date LIKE ?';
      whereArgs.add('$dateStr%');
    }

    final List<Map<String, dynamic>> maps = await db.query(
      _nutritionTable,
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => NutritionEntry.fromJson(map)).toList();
  }

  Future<void> updateNutritionEntry(NutritionEntry entry) async {
    final db = await database;
    await db.update(
      _nutritionTable,
      entry.toJson(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<void> deleteNutritionEntry(String id) async {
    final db = await database;
    await db.delete(
      _nutritionTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getTotalCaloriesByDate(String userId, DateTime date) async {
    final db = await database;
    final dateStr = date.toIso8601String().split('T')[0];
    
    final result = await db.rawQuery('''
      SELECT SUM(calories) as total_calories
      FROM $_nutritionTable
      WHERE user_id = ? AND date LIKE ?
    ''', [userId, '$dateStr%']);

    return result.first['total_calories'] as int? ?? 0;
  }

  Future<Map<String, double>> getMacrosByDate(String userId, DateTime date) async {
    final db = await database;
    final dateStr = date.toIso8601String().split('T')[0];
    
    final result = await db.rawQuery('''
      SELECT 
        SUM(protein) as total_protein,
        SUM(carbs) as total_carbs,
        SUM(fats) as total_fats
      FROM $_nutritionTable
      WHERE user_id = ? AND date LIKE ?
    ''', [userId, '$dateStr%']);

    final row = result.first;
    return {
      'protein': (row['total_protein'] as num?)?.toDouble() ?? 0.0,
      'carbs': (row['total_carbs'] as num?)?.toDouble() ?? 0.0,
      'fats': (row['total_fats'] as num?)?.toDouble() ?? 0.0,
    };
  }

  // Users CRUD
  Future<void> insertUser(UserModel user) async {
    final db = await database;
    await db.insert(
      _usersTable,
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserModel?> getUser(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _usersTable,
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromJson(maps.first);
    }
    return null;
  }

  Future<void> updateUser(UserModel user) async {
    final db = await database;
    await db.update(
      _usersTable,
      user.toJson(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> deleteUser(String userId) async {
    final db = await database;
    await db.delete(
      _usersTable,
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // Progress Entries CRUD
  Future<void> insertProgressEntry(ProgressEntry entry) async {
    final db = await database;
    await db.insert(
      _progressTable,
      entry.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ProgressEntry>> getProgressEntries(String userId, String? type, DateTime? date) async {
    final db = await database;
    String whereClause = 'user_id = ?';
    List<dynamic> whereArgs = [userId];

    if (type != null) {
      whereClause += ' AND type = ?';
      whereArgs.add(type);
    }

    if (date != null) {
      final dateStr = date.toIso8601String().split('T')[0];
      whereClause += ' AND date LIKE ?';
      whereArgs.add('$dateStr%');
    }

    final List<Map<String, dynamic>> maps = await db.query(
      _progressTable,
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => ProgressEntry.fromJson(map)).toList();
  }

  Future<void> updateProgressEntry(ProgressEntry entry) async {
    final db = await database;
    await db.update(
      _progressTable,
      entry.toJson(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<void> deleteProgressEntry(String id) async {
    final db = await database;
    await db.delete(
      _progressTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Analytics and reporting
  Future<Map<String, dynamic>> getNutritionSummary(String userId, DateTime startDate, DateTime endDate) async {
    final db = await database;
    final startStr = startDate.toIso8601String().split('T')[0];
    final endStr = endDate.toIso8601String().split('T')[0];
    
    final result = await db.rawQuery('''
      SELECT 
        COUNT(*) as total_entries,
        SUM(calories) as total_calories,
        AVG(calories) as avg_calories,
        SUM(protein) as total_protein,
        SUM(carbs) as total_carbs,
        SUM(fats) as total_fats
      FROM $_nutritionTable
      WHERE user_id = ? AND date BETWEEN ? AND ?
    ''', [userId, startStr, endStr]);

    return result.first;
  }

  Future<List<Map<String, dynamic>>> getCalorieTrends(String userId, int days) async {
    final db = await database;
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: days));
    final startStr = startDate.toIso8601String().split('T')[0];
    final endStr = endDate.toIso8601String().split('T')[0];
    
    final result = await db.rawQuery('''
      SELECT 
        DATE(date) as date,
        SUM(calories) as total_calories
      FROM $_nutritionTable
      WHERE user_id = ? AND date BETWEEN ? AND ?
      GROUP BY DATE(date)
      ORDER BY date ASC
    ''', [userId, startStr, endStr]);

    return result;
  }

  // Cleanup and maintenance
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete(_nutritionTable);
    await db.delete(_usersTable);
    await db.delete(_progressTable);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/member.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();
  
  static Database? _database;
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'kp_gym.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }
  
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE members(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        joiningDate INTEGER NOT NULL,
        subscriptionDays INTEGER NOT NULL DEFAULT 30,
        amount REAL NOT NULL,
        isMorningShift INTEGER NOT NULL DEFAULT 1
      )
    ''');
  }
  
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Drop and recreate the table to ensure proper schema
      await db.execute('DROP TABLE IF EXISTS members');
      await _onCreate(db, newVersion);
    }
  }
  
  // CRUD Operations for Members
  
  // Create
  Future<int> insertMember(Member member) async {
    final db = await database;
    return await db.insert(
      'members',
      member.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  // Read
  Future<List<Member>> getMembers({bool? isMorningShift}) async {
    final db = await database;
    
    // If shift filter is provided, apply it
    List<Map<String, dynamic>> maps;
    if (isMorningShift != null) {
      maps = await db.query(
        'members',
        where: 'isMorningShift = ?',
        whereArgs: [isMorningShift ? 1 : 0],
      );
    } else {
      maps = await db.query('members');
    }
    
    return List.generate(maps.length, (i) {
      return Member.fromMap(maps[i]);
    });
  }
  
  // Get a single member by ID
  Future<Member?> getMember(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'members',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isNotEmpty) {
      return Member.fromMap(maps.first);
    }
    return null;
  }
  
  // Update
  Future<int> updateMember(Member member) async {
    final db = await database;
    return await db.update(
      'members',
      member.toMap(),
      where: 'id = ?',
      whereArgs: [member.id],
    );
  }
  
  // Delete
  Future<int> deleteMember(int id) async {
    final db = await database;
    return await db.delete(
      'members',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  // Get members about to expire (1 day remaining)
  Future<List<Member>> getMembersAboutToExpire() async {
    final allMembers = await getMembers();
    return allMembers.where((member) => member.isAboutToExpire).toList();
  }
  
  // Get current month income
  Future<double> getCurrentMonthIncome() async {
    final db = await database;
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 1).subtract(const Duration(days: 1));
    
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT SUM(amount) as totalAmount 
      FROM members 
      WHERE joiningDate >= ? AND joiningDate <= ?
      AND (joiningDate + (subscriptionDays * 86400000)) >= ?
    ''', [
      startOfMonth.millisecondsSinceEpoch,
      endOfMonth.millisecondsSinceEpoch,
      startOfMonth.millisecondsSinceEpoch
    ]);
    
    return (result.first['totalAmount'] ?? 0.0).toDouble();
  }
  
  // Get total income
  Future<double> getTotalIncome() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT SUM(amount) as totalAmount FROM members'
    );
    
    return result.first['totalAmount'] ?? 0.0;
  }
}
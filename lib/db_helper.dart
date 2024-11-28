import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  DBHelper._internal();

  factory DBHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'food_orders.db');
    return openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE orders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT,
            target_cost TEXT,
            plan TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  Future<int> insertOrder(String date, String targetCost, String plan) async {
    final db = await database;
    return db.insert('orders', {'date': date, 'target_cost': targetCost, 'plan': plan});
  }

  Future<List<Map<String, dynamic>>> fetchOrders() async {
    final db = await database;
    return db.query('orders');
  }

  Future<int> deleteOrder(int id) async {
    final db = await database;
    return db.delete('orders', where: 'id = ?', whereArgs: [id]);
  }

  insertDefaultFoodItems() async {
    final db = await database;
    final defaultItems = [
      {'name': 'Pizza', 'cost': 10.0},
      {'name': 'Burger', 'cost': 7.0},
      {'name': 'Pasta', 'cost': 8.5},
      {'name': 'Salad', 'cost': 5.0},
      {'name': 'Sandwich', 'cost': 6.0},
      {'name': 'Sushi', 'cost': 12.0},
      {'name': 'Steak', 'cost': 15.0},
      {'name': 'Tacos', 'cost': 8.0},
      {'name': 'Fries', 'cost': 3.5},
      {'name': 'Hot Dog', 'cost': 4.0},
      {'name': 'Fried Chicken', 'cost': 9.0},
      {'name': 'Nachos', 'cost': 7.5},
      {'name': 'Curry', 'cost': 11.0},
      {'name': 'Ramen', 'cost': 9.5},
      {'name': 'Dumplings', 'cost': 8.0},
      {'name': 'Ice Cream', 'cost': 3.0},
      {'name': 'Cheesecake', 'cost': 5.5},
      {'name': 'Brownie', 'cost': 4.5},
      {'name': 'Smoothie', 'cost': 4.0},
      {'name': 'Coffee', 'cost': 2.5},
    ];
    for (var item in defaultItems) {
      await db.insert('food_items', item, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
  }
}

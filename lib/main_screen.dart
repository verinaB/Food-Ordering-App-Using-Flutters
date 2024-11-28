import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'add_food_screen.dart';
import 'query_orders_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late DBHelper dbHelper;
  List<Map<String, dynamic>> foodItems = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadFoodItems();
  }

  Future<void> loadFoodItems() async {
    await dbHelper.insertDefaultFoodItems(); // Prepopulate database
    final db = await dbHelper.database;
    final items = await db.query('food_items');
    setState(() {
      foodItems = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Food Ordering App')),
      body: ListView.builder(
        itemCount: foodItems.length,
        itemBuilder: (context, index) {
          final item = foodItems[index];
          return ListTile(
            title: Text(item['name']),
            subtitle: Text('Cost: \$${item['cost']}'),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddFoodScreen()),
              );
            },
            tooltip: 'Add Food Item',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QueryOrdersScreen()),
              );
            },
            tooltip: 'Query Orders',
            child: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}

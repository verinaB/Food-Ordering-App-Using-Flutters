import 'package:flutter/material.dart';
import 'db_helper.dart';

class QueryOrdersScreen extends StatelessWidget {
  final TextEditingController dateController = TextEditingController();
  final DBHelper dbHelper = DBHelper();

  QueryOrdersScreen({super.key});

  Future<List<Map<String, dynamic>>> fetchOrders(String date) async {
    final db = await dbHelper.database;
    return await db.query('order_plans', where: 'date = ?', whereArgs: [date]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Query Orders')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: dateController,
              decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final date = dateController.text;
                final orders = await fetchOrders(date);

                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Orders for $date'),
                      content: orders.isNotEmpty
                          ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: orders.map((order) {
                          return Text('Items: ${order['selected_items']}');
                        }).toList(),
                      )
                          : const Text('No orders found'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Search Orders'),
            ),
          ],
        ),
      ),
    );
  }
}

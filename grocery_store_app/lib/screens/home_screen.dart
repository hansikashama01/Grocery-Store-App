import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/grocery_item.dart';
import '../widgets/grocery_item_card.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<GroceryItem> _items = [];

  /// Fetch grocery items from the JSON file
  Future<void> _fetchItems() async {
    try {
      final data = await DefaultAssetBundle.of(context).loadString('assets/data/grocery_items.json');
      final List<dynamic> jsonResult = json.decode(data);
      setState(() {
        _items = jsonResult.map((item) => GroceryItem.fromJson(item)).toList();
      });
    } catch (e) {
      print('Error loading JSON data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchItems(); // Load grocery items at startup
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grocery Store', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green.shade700,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Welcome message and search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to the Grocery Store!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for items...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                  ),
                ),
              ],
            ),
          ),
          // Display items in a grid
          Expanded(
            child: _items.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(), // Show a loading spinner
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 items per row
                      childAspectRatio: 3 / 4,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _items.length,
                    itemBuilder: (ctx, index) => GroceryItemCard(item: _items[index]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => CartScreen()),
          );
        },
        label: Text('Cart'),
        icon: Icon(Icons.shopping_cart),
        backgroundColor: Colors.green.shade700,
      ),
    );
  }
}

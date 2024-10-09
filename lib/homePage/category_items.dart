import 'dart:convert';

import 'package:flutter/material.dart';

import '../task8_helper/login_page.dart';
import '../task8_helper/task8_db_helper.dart';

class Item_category extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final String additionalString;

  Item_category({
    required this.items,
    required this.additionalString,
  });

  @override
  _Item_categoryState createState() => _Item_categoryState();
}

class _Item_categoryState extends State<Item_category> {
  // Maintain a list of items in the Wishlist
  List<Map<String, dynamic>> _wishListItems = [];

  // Function to add/remove an item to/from the wishlist
  void _toggleWishListItem(Map<String, dynamic> item) {
    // Check if the item is already in the wishlist
    if (_wishListItems.contains(item)) {
      // Remove the item from the wishlist
      setState(() {
        _wishListItems.remove(item);
      });
    } else {
      // Add the item to the wishlist
      setState(() {
        _wishListItems.add(item);
      });
    }
  }

  // Function to submit the wishlist items
  final dbhelper = task8_db.instance;
  List<Map<String, dynamic>> userItems = [];
  List<Map<String, dynamic>> items2 = [];

  Future<List<Map<String, dynamic>>> _fetchUserItems(String userId) async {
    try {
      userItems = await dbhelper.querySpacific(userId);
      setState(() {});
      return userItems;
    } catch (e) {
      print('Error fetching user items: $e');
      return [];
    }
  }

  Future<void> _submitWishList() async {
    // Fetch the current user
    await _fetchUserItems(widget.additionalString);

    for (Map<String, dynamic> userItem in userItems) {
      var itemList = userItem['item_list'];
      items2 = List<Map<String, dynamic>>.from(json.decode(itemList));
    }

    List<Map<String, dynamic>> mergedItems =
        _mergeItems(_wishListItems, items2);

    try {
      await dbhelper.updateSpecificUserItems(
          widget.additionalString, mergedItems);
      print('Updated existing items');
    } catch (e) {
      print('Error updating items data: $e');
    }

    setState(() {
      _wishListItems.clear();
    });
  }

  List<Map<String, dynamic>> _mergeItems(List<Map<String, dynamic>> newItems,
      List<Map<String, dynamic>> existingItems) {
    Map<String, Map<String, dynamic>> mergedMap = {};

    for (var item in existingItems) {
      mergedMap[item['title']] = item;
    }

    for (var item in newItems) {
      mergedMap[item['title']] = item;
    }

    return mergedMap.values.toList();
  }

  // Function to show the login dialog
  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Required'),
          content: const Text('Please login to add items to the WishList.'),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel')),
            ElevatedButton(
              child: const Text('Login'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        title: Text('Well Come ${widget.additionalString}'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final item = widget.items[index];
          return Container(
            padding: const EdgeInsets.all(8.0),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: item['image'].startsWith('http')
                        ? Image.network(
                      item['image'],
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child; // Image has finished loading, show the image
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                          ), // Show loading spinner
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    )
                        : Image.asset(
                      item['image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          item['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          item['data'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < item['rating'].floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.deepPurple,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      '\$${item['price'].toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    ElevatedButton(
                      onPressed: widget.additionalString.isEmpty
                          ? _showLoginDialog
                          : () => _toggleWishListItem(item),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _wishListItems.contains(item)
                            ? Colors.green
                            : Colors.blue,
                      ),
                      child: Text(_wishListItems.contains(item)
                          ? '   Remove   '
                          : 'Add to WishList'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      // Show the FloatingActionButton only if the wishlist is not empty
      floatingActionButton: _wishListItems.isNotEmpty
          ? FloatingActionButton(
              onPressed: _submitWishList,
              child: const Icon(Icons.check),
            )
          : null,
    );
  }
}
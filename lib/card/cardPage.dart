import 'dart:convert';
import 'package:flutter/material.dart';
import '../task8_helper/task8_db_helper.dart';

class card_page extends StatefulWidget {
  @override
  _card_page createState() => _card_page();

  final String additionalString;
  card_page({super.key, this.additionalString = ''});
}

class _card_page extends State<card_page> {
  @override
  void initState() {
    super.initState();
    querySpecificUserItems(widget.additionalString);
  }

  final dbhelper = task8_db.instance;
  List<Map<String, dynamic>> items = []; //fetched Item as a String
  List<Map<String, dynamic>> items2 = []; // updated item as a list
  List<Map<String, dynamic>> selectedItems = []; // items selected for buying

  _toggleCartItem(Map<String, dynamic> item) {
    setState(() {
      items2.remove(item);
    });
  }

  void _toggleBy(Map<String, dynamic> item) {
    // Check if the item is already in the cart
    if (selectedItems.contains(item)) {
      // Remove the item from the cart
      setState(() {
        selectedItems.remove(item);
      });
    } else {
      // Add the item to the cart
      setState(() {
        selectedItems.add(item);
      });
    }
  }

  Future<void> update() async {
    try {
      await dbhelper.updateSpecificUserItems(widget.additionalString, items2);
      print('Updated existing items');
    } catch (e) {
      print('Error updating items data: $e');
    }
  }

  void querySpecificUserItems(String User) async {
    items = await dbhelper.querySpacific(User);
    for (Map<String, dynamic> userItem in items) {
      var itemList = userItem['item_list'];
      if (itemList is String) {
        List<dynamic> itemListDynamic = json.decode(itemList);
        items2 = itemListDynamic.map((item) => Map<String, dynamic>.from(item)).toList();
      } else if (itemList is List) {
        items2 = itemList.map((item) => Map<String, dynamic>.from(item)).toList();
      }
    }
    setState(() {});
  }

  double getTotalPrice() {
    return selectedItems.fold(0.0, (sum, item) => sum + item['price']);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      body: Stack(
        children: [
          ListView.builder(
            itemCount: items2.length,
            itemBuilder: (context, index) {
              final item = items2[index];
              return Container(
                padding: EdgeInsets.all(8.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(37.5),
                            image: item['image'].startsWith('http')
                                ? DecorationImage(
                              image: NetworkImage(item['image']),
                              fit: BoxFit.cover,
                            )
                                : DecorationImage(
                              image: AssetImage(item['image']),
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
                                  style: TextStyle(
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
                                    fontSize: 15,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              item['rating'].toString(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              height: 20,
                              width: 30,
                              color: item['rating'] > 3 ? Colors.green : Colors.red,
                              child: Center(
                                child: Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              '\$${item['price'].toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _toggleCartItem(item);
                              update();
                              querySpecificUserItems(widget.additionalString);
                            },
                            child: Text('Remove From Cart'),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => _toggleBy(item),
                          child: Text(selectedItems.contains(item) ? 'Remove from Buy' : 'Add to Buy'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedItems.contains(item) ? Colors.green : Colors.blue,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
          if (selectedItems.isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total: \$${getTotalPrice().toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Items: ${selectedItems.length}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('Proceed'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

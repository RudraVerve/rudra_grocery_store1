import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rudra_grocery_store09/card/proceed_buy_page.dart';
import '../task8_helper/task8_db_helper.dart';

class card_page extends StatefulWidget {
  final String additionalString;
  bool showProceedMessage;

  card_page(
      {Key? key, this.additionalString = '', this.showProceedMessage = true})
      : super(key: key);

  @override
  _card_page createState() => _card_page();
}

class _card_page extends State<card_page> {
  final dbhelper = task8_db.instance;
  List<Map<String, dynamic>> items = []; // Fetched items as a string
  List<Map<String, dynamic>> items2 = []; // Updated items as a list
  List<Map<String, dynamic>> selectedItems = []; // Items selected for buying

  @override
  void initState() {
    super.initState();
    querySpecificUserItems(widget.additionalString);
  }

  void _toggleCartItem(Map<String, dynamic> item) {
    setState(() {
      items2.remove(item);
    });
  }

  void _addBuyItem(Map<String, dynamic> item) {
    setState(() {
      selectedItems.add(item);
    });
  }

  void _removeBuyItem(Map<String, dynamic> item) {
    setState(() {
      selectedItems.remove(item);
    });
  }

  Future<void> update() async {
    try {
      await dbhelper.updateSpecificUserItems(widget.additionalString, items2);
      print('Updated existing items');
    } catch (e) {
      print('Error updating items data: $e');
    }
  }

  void querySpecificUserItems(String user) async {
    items = await dbhelper.querySpacific(user);
    for (Map<String, dynamic> userItem in items) {
      var itemList = userItem['item_list'];
      if (itemList is String) {
        List<dynamic> itemListDynamic = json.decode(itemList);
        items2 = itemListDynamic
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      } else if (itemList is List) {
        items2 =
            itemList.map((item) => Map<String, dynamic>.from(item)).toList();
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
          if (items2.isEmpty)
            Center(
              child: Text(
                'No Selected Card Items',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ListView.builder(
            itemCount: items2.isNotEmpty ? items2.length : 1,
            // Show 1 item for the message if items2 is empty
            itemBuilder: (context, index) {
              if (items2.isEmpty) {
                return SizedBox(); // If items2 is empty, return an empty SizedBox
              }
              final item = items2[index];
              int count = 0;
              for (var itemcount in selectedItems) {
                if (item == itemcount) {
                  count++;
                }
              }
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
                              color: item['rating'] > 4
                                  ? Colors.green
                                  : item['rating'] > 3
                                      ? Colors.orange
                                      : Colors.red,
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
                        selectedItems.contains(item)
                            ? Container(
                                height: 30,
                                width: 120,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _removeBuyItem(item);

                                        setState(() {
                                          widget.showProceedMessage = true;
                                        });
                                        Timer(Duration(seconds: 5), () {
                                          setState(() {
                                            widget.showProceedMessage = false;
                                          });
                                        });
                                      },
                                      icon: Icon(
                                        Icons.remove,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                    ),
                                    Text(
                                      '${count}',
                                      textAlign: TextAlign.center,
                                      // Ensure text is centered
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _addBuyItem(item);

                                        setState(() {
                                          widget.showProceedMessage = true;
                                        });
                                        Timer(Duration(seconds: 5), () {
                                          setState(() {
                                            widget.showProceedMessage = false;
                                          });
                                        });
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        color: Colors.deepPurpleAccent,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  _addBuyItem(item);

                                  setState(() {
                                    widget.showProceedMessage = true;
                                  });
                                  Timer(Duration(seconds: 5), () {
                                    setState(() {
                                      widget.showProceedMessage = false;
                                    });
                                  });
                                },
                                child: Text('Add TO Buy')),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
          if (selectedItems.isNotEmpty && widget.showProceedMessage)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BuyPage(items: selectedItems, additionalString: widget.additionalString),
                              ),
                            );
                          },
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

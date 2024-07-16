import 'dart:convert';
import 'package:flutter/material.dart';
import '../homePage/category_items.dart';
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
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> items2 = [];

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
    print(items2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Item_category(items: items2 ,additionalString: widget.additionalString),
    );
  }
}
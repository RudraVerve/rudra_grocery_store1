import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rudra_grocery_store09/task8_helper/task8_db_helper.dart';
import '../../myOrders/OrderDetails.dart';
import '../../myOrders/orderCategory.dart';

class SellerHomePage extends StatefulWidget {
  const SellerHomePage({super.key});

  @override
  State<SellerHomePage> createState() => _SellerHomePageState();
}

class _SellerHomePageState extends State<SellerHomePage> {
  final List<Map<String, dynamic>> orderCategory = [
    {'color': Colors.purple, 'text': 'All Ordered'},
    {'color': Colors.orange, 'text': 'Pending'},
    {'color': Colors.green, 'text': 'In process...'},
    {'color': Colors.blue, 'text': 'Delivered'},
    {'color': Colors.red, 'text': 'Canceled\nBy Seller'},
    {'color': Colors.brown, 'text': 'Most Urgent'},
    {'color': Colors.pinkAccent, 'text': 'Complete'},
    {'color': Colors.teal, 'text': 'Canceled\nBy User'},
  ];

  DateTime? _selectedDate;
  String _formattedDate = '';

  // Function to show the date picker dialog
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _formattedDate = DateFormat('yy-MM-dd').format(pickedDate);
        _refreshOrders();
      });
    }
  }

  late Future<List<Map<String, dynamic>>> ordersDate;

  void _refreshOrders() {
    setState(() {
      ordersDate = task8_db.instance.getOrdersByDate(_formattedDate);
    });
  }

  @override
  void initState() {
    super.initState();
    // Set default date to today and initialize ordersDate
    _formattedDate = DateFormat('yy-MM-dd').format(DateTime.now());
    _refreshOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'NextGen Online',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  fontFamily: 'LibreBaskerville',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: const DecorationImage(
                    image: AssetImage('assets/image/TotalRevenue.webp'),
                    fit: BoxFit.cover,
                    opacity: 0.9,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Total Revenue',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          fontFamily: 'LibreBaskerville',
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '\$ 620,340.30',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          fontFamily: 'LibreBaskerville',
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Investment: \$ 32,098.23',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                fontFamily: 'LibreBaskerville',
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.check_circle,
                            color: Colors.orange,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Text(
                              'Total Profit: \$ 30,340.30',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                fontFamily: 'LibreBaskerville',
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Order Category',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'LibreBaskerville',
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orderCategory.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 3 / 2,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderCategory(index: index),
                        ),
                      ).then((value) {
                        if (value == true) {
                          setState(() {
                            _refreshOrders();
                          });
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: orderCategory[index]['color'],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          orderCategory[index]['text'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Order Date',
                        style: TextStyle(
                          fontFamily: 'LibreBaskerville',
                          fontSize: 19,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await _selectDate(context);
                        },
                        child: const Text('Select Date'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: ordersDate,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child:
                          Text('No orders found for date ${_formattedDate}'));
                } else {
                  final orderList = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orderList.length,
                    itemBuilder: (context, index) {
                      final order = orderList[index];
                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            const BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              child: ListTile(
                                title: Text('Order ID: ${order['order_id']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                    'Total Price: \$${order['total_price']}'),
                                trailing: Column(
                                  children: [
                                    Container(
                                      height: 30,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: order['IsOrder_Cancel'] == 1 ||
                                                order['IsOrder_Cancel_User'] ==
                                                    1
                                            ? Colors.red
                                            : order['Received_ByUser'] == 1 &&
                                                    order['is_completed'] == 1
                                                ? Colors.black
                                                : order['is_completed'] == 1
                                                    ? Colors.green
                                                    : order['is_approved'] == 1
                                                        ? Colors.green
                                                        : Colors.orange,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Text(
                                          order['IsOrder_Cancel'] == 1
                                              ? 'SellerCanceled'
                                              : order['IsOrder_Cancel_User'] ==
                                                      1
                                                  ? 'UserCanceled'
                                                  : order['Received_ByUser'] ==
                                                              1 &&
                                                          order['is_completed'] ==
                                                              1
                                                      ? 'Completed'
                                                      : order['is_completed'] ==
                                                              1
                                                          ? 'Delivered'
                                                          : order['is_approved'] ==
                                                                  1
                                                              ? 'In process...'
                                                              : 'Pending...',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Text('Date: $_formattedDate'),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderDetails(
                                        orderId: order['order_id'],
                                        userId: order['user_id']),
                                  ),
                                ).then((value) {
                                  if (value == true) {
                                    setState(() {
                                      _refreshOrders();
                                    });
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'dart:convert';
import '../task8_helper/task8_db_helper.dart';
import 'package:intl/intl.dart';

class OrdersPage extends StatefulWidget {
  final int userId;

  OrdersPage({required this.userId});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late Future<List<Map<String, dynamic>>> orders;

  @override
  void initState() {
    super.initState();
    _refreshOrders();
  }

  void _refreshOrders() {
    setState(() {
      orders = task8_db.instance.getOrdersForUser(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Orders'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: orders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No orders found.'));
          } else {
            final orderList = snapshot.data!;

            return ListView.builder(
              itemCount: orderList.length,
              itemBuilder: (context, index) {
                final order = orderList[index];
                final orderDetailsJson = order['order_details'] as String;
                final orderDetails = jsonDecode(orderDetailsJson) as List<dynamic>;

                // Ensure date parsing
                final dateString = order['date'] as String;
                final date = DateTime.parse(dateString);
                final formattedDate = DateFormat('yyyy-MM-dd').format(date);

                return Container(
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExpansionTile(
                        title: Text('Order ID: ${order['order_id']}', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Total Price: \$${order['total_price']}'),
                        trailing: Column(
                          children: [
                            Container(
                              height: 30,
                              width: 100,
                              decoration: BoxDecoration(
                                color: order['IsOrder_Cancel'] == 1 ? Colors.red : order['OrderIsApproved'] == 1 ? Colors.greenAccent : Colors.orange,
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Center(
                                child: Text(
                                  order['IsOrder_Cancel'] == 1 ? 'Canceled' : order['OrderIsApproved'] == 1 ? 'Approved' : 'Pending...',
                                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Text('Date: $formattedDate'),
                          ],
                        ),

                        children: [
                          ...orderDetails.map((detail) {
                            return ListTile(
                              leading: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  image: detail['image'] != null
                                      ? DecorationImage(
                                    image: detail['image'].startsWith('http')
                                        ? NetworkImage(detail['image'])
                                        : AssetImage(detail['image']) as ImageProvider,
                                    fit: BoxFit.cover,
                                  )
                                      : null,
                                ),
                              ),
                              title: Text('Quantity: ${detail['quantity'] ?? 'No quantity'}'),
                              trailing: Text('Price: ${detail['price'] ?? 'No price'}'),
                            );
                          }).toList(),
                          SizedBox(height: 20),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                if (order['is_approved'] == 0 && order['IsOrder_Cancel'] == 0) ...[
                                  ElevatedButton(
                                      onPressed: ()async {
                                        if(order['Notify_Seller']==0){
                                          await task8_db.instance.updateNotify_Seller(order['order_id']);
                                          _refreshOrders();
                                        }
                                      },
                                      child: Text('Notify Seller'),
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                                              (states) {
                                            return order['Notify_Seller'] == 1 ? Colors.green : null;
                                          },
                                        ),
                                      ),
                                  ),
                                  ElevatedButton(onPressed: () async {
                                    await task8_db.instance.updateOrderStatus(order['order_id']);
                                    _refreshOrders();
                                  }, child: Text('Cancel Order')),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
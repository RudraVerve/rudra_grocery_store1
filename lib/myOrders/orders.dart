import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:rudra_grocery_store09/task8_helper/task8_db_helper.dart';

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
                                color: order['IsOrder_Cancel'] == 1 || order['IsOrder_Cancel_User'] == 1
                                    ? Colors.red
                                    : order['Received_ByUser'] == 1 && order['is_completed'] == 1
                                    ? Colors.black
                                    :order['is_completed'] == 1
                                    ? Colors.green
                                    :order['is_approved'] == 1
                                    ? Colors.green
                                    : Colors.orange,
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Center(
                                child: Text(
                                  order['IsOrder_Cancel'] == 1
                                  ? 'SellerCanceled'
                                  : order['IsOrder_Cancel_User'] == 1
                                  ? 'UserCanceled'
                                  : order['Received_ByUser'] == 1 && order['is_completed'] == 1
                                  ? 'Completed'
                                  :order['is_completed'] == 1
                                  ? 'Delivered'
                                  : order['is_approved'] == 1
                                  ? 'In process...'
                                  : 'Pending...',
                                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Text('Date: $dateString'),
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
                          const SizedBox(height: 20),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                if (order['is_approved'] == 0 && order['IsOrder_Cancel'] == 0 && order['IsOrder_Cancel_User'] == 0 && (order['is_completed'] == 0 && order['Received_ByUser'] == 0)) ...[
                                  ElevatedButton(
                                      onPressed: ()async {
                                        if(order['Notify_Seller']==0){
                                          await task8_db.instance.updateNotifySeller(order['order_id'],true);
                                          _refreshOrders();
                                        }
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                                              (states) {
                                            return order['Notify_Seller'] == 1 ? Colors.green : null;
                                          },
                                        ),
                                      ),
                                      child: const Text('Notify Seller'),
                                  ),
                                  ElevatedButton(onPressed: () async {
                                    await task8_db.instance.updateOrderCancelUser(order['order_id'],true);
                                    _refreshOrders();
                                  }, child: const Text('Cancel Order')),
                                ]
                                else if(order['is_completed'] == 1 && order['Received_ByUser'] == 0) ...[
                                  ElevatedButton(
                                    onPressed: ()async {
                                      if(order['Received_ByUser']==0){
                                        await task8_db.instance.updateReceived(order['order_id'],true);
                                        _refreshOrders();
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                                            (states) {
                                          return order['Received_ByUser'] == 1 ? Colors.green : null;
                                        },
                                      ),
                                    ),
                                    child: const Text('Received'),
                                  ),
                                ]
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
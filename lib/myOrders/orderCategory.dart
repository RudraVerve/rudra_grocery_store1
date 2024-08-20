import 'package:flutter/material.dart';
import 'package:rudra_grocery_store09/task8_helper/task8_db_helper.dart';
import 'OrderDetails.dart';

class OrderCategory extends StatefulWidget {
  final int index;
  const OrderCategory({super.key, required this.index});

  @override
  State<OrderCategory> createState() => _OrderCategoryState();
}

class _OrderCategoryState extends State<OrderCategory> {
  late Future<List<Map<String, dynamic>>> Orders;

  void _refreshOrders() {
    setState(() {
      if (widget.index == 0) {
        Orders = task8_db.instance.queryallOrders();
      } else if (widget.index == 1) {
        Orders = task8_db.instance.getPendingOrders();
      } else if (widget.index == 2) {
        Orders = task8_db.instance.getApprovedOrders();
      } else if (widget.index == 3) {
        Orders = task8_db.instance.getDeliveredOrders();
      } else if (widget.index == 4) {
        Orders = task8_db.instance.getCanceledOrdersBySeller();
      } else if (widget.index == 5) {
        Orders = task8_db.instance.getMostUrgentOrders();
      } else if (widget.index == 6) {
        Orders = task8_db.instance.getCompletedOrder();
      }else if (widget.index == 7) {
        Orders = task8_db.instance.getCanceledOrdersByUser();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true); // Pass true to indicate update
          },
        ),
        title: const Text('Orders...'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: Orders,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)));
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
                      boxShadow: const [
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
                        InkWell(
                          child: ListTile(
                            title: Text('Order ID: ${order['order_id']}', style: const TextStyle(fontWeight: FontWeight.bold)),
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
                                        : order['is_approved'] == 1
                                        ? Colors.green
                                        : Colors.orange,
                                    borderRadius: BorderRadius.circular(20),
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
                                          ? 'Approved'
                                          : 'Pending...',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Text('Date: ${order['date']}'),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderDetails(orderId: order['order_id'], userId: order['user_id']),
                              ),
                            ).then((value) {
                              if (value == true) {
                                _refreshOrders(); // Refresh the orders if necessary
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
      ),
    );
  }
}

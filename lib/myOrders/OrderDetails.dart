import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rudra_grocery_store09/task8_helper/task8_db_helper.dart';

class OrderDetails extends StatefulWidget {
  final int orderId;
  final int userId;
  const OrderDetails({super.key, required this.orderId, required this.userId});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final dbhelper = task8_db.instance;
  List<Map<String, dynamic>> userData = [];
  dynamic orderList;
  dynamic order;
  dynamic orderDetailsJson;
  dynamic orderDetails;

  bool isLoading = true; // Indicator to track loading state
  Map<String, dynamic> address = {}; // Variable to store the address

  @override
  void initState() {
    super.initState();
    _refreshOrders();
  }

  void _refreshOrders() async {
    try {
      orderList = await dbhelper.getOrdersByOrderId(widget.orderId);
      userData = await dbhelper.querySpacificUserUsingUserId(widget.userId);

      if (orderList.isNotEmpty) {
        order = orderList[0];
        orderDetailsJson = order['order_details'] as String? ?? '[]';
        orderDetails = jsonDecode(orderDetailsJson) as List<dynamic>;
        address = jsonDecode(userData[0]['Adress${order['Order_AddressNo']}']);
      } else {
        orderDetails = [];
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true); // Pass true to indicate update
          },
        ),
        title: Text('Order ID: ${widget.orderId}', style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order details section
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ListTile(
                      title: Text(
                        'Order ID: ${order['order_id']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
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
                          Text(
                            'Date: ${order['date']}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.amberAccent),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Order items list section
                  if (orderDetails != null && orderDetails.isNotEmpty)
                    ...orderDetails.map<Widget>((detail) {
                      return ListTile(
                        leading: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            image: detail['image'] != null
                                ? DecorationImage(
                              image: detail['image']
                                  .startsWith('http')
                                  ? NetworkImage(detail['image'])
                                  : AssetImage(detail['image'])
                              as ImageProvider,
                              fit: BoxFit.cover,
                            )
                                : null,
                          ),
                        ),
                        title: Text(
                            'Quantity: ${detail['quantity'] ?? 'No quantity'}'),
                        trailing: Text(
                            'Price: ${detail['price'] ?? 'No price'}'),
                        subtitle: Text(detail['data']),
                      );
                    }).toList()
                  else
                    const Center(child: Text('No order details available.')),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'User Details',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'LibreBaskerville'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name: ${address.isNotEmpty ? address['name'] : 'No name'}"),
                  Text("Mobile number: ${userData.isNotEmpty ? userData[0]['Mobile'] : 'No data'}"),
                  Text("Mail ID: ${userData.isNotEmpty ? userData[0]['mail'] : 'No data'}"),
                  Text("City: ${address.isNotEmpty ? address['city'] : 'No city'}"),
                  Text("PinCode: ${address.isNotEmpty ? address['pin'] : 'No pinCode'}"),
                  Text("Post Office: ${address.isNotEmpty ? address['post'] : 'No post'}"),
                  Text("House Name: ${address.isNotEmpty ? address['houseName'] : 'No houseName'}"),
                  Text("Near Landmark: ${address.isNotEmpty ? address['landmark'] : 'No landmark'}"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if ((order['IsOrder_Cancel_User'] == 0) && (order['is_completed'] == 0 &&  order['Received_ByUser'] == 0) && (order['is_completed'] == 0)) ...[
                    ElevatedButton(
                      onPressed: ()async{
                        await task8_db.instance.updateOrderApproval(order['order_id'],true);
                        await task8_db.instance.updateNotifySeller(order['order_id'],false);
                        await task8_db.instance.updateOrderCancelSeller(order['order_id'],false);
                        await task8_db.instance.updateCompleted(order['order_id'],false);
                        _refreshOrders();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Approve'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await task8_db.instance.updateOrderCancelSeller(order['order_id'],true);
                        await task8_db.instance.updateOrderApproval(order['order_id'],false);
                        await task8_db.instance.updateCompleted(order['order_id'],false);
                        _refreshOrders();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Set the background color to red
                      ),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: ()async{
                        await task8_db.instance.updateCompleted(order['order_id'],true);
                        await task8_db.instance.updateOrderCancelSeller(order['order_id'],false);
                        await task8_db.instance.updateOrderApproval(order['order_id'],false);
                        await task8_db.instance.updateNotifySeller(order['order_id'],false);
                        _refreshOrders();
                      },
                      child: Text('Delivered'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                      ),
                    ),
                  ]
                  else if(order['IsOrder_Cancel_User'] == 1)...[
                    ElevatedButton(
                      onPressed: ()async{
                        await task8_db.instance.deleteSpecificOrder(order['order_id']);
                        Navigator.pop(context, true);
                      },
                      child: Text('Delete Order'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown, // Set the background color to red
                      ),
                    ),
                  ]
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
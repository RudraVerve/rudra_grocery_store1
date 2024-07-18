import 'package:flutter/material.dart';

class BuyPage extends StatefulWidget {
  final List<Map<String, dynamic>> items;

  const BuyPage({super.key, required this.items});

  @override
  State<BuyPage> createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  List<Map<String, dynamic>> processedItems = [];
  double gstRate = 0.12; //gst

  @override
  void initState() {
    super.initState();
    processItems();
  }

  void processItems() {
    Map<String, Map<String, dynamic>> itemMap = {};

    for (var item in widget.items) {
      if (itemMap.containsKey(item['title'])) {
        itemMap[item['title']]!['quantity'] += 1;
        itemMap[item['title']]!['totalPrice'] += item['price'];
      } else {
        itemMap[item['title']] = {
          'image': item['image'],
          'title': item['title'],
          'rating': item['rating'],
          'price': item['price'],
          'data': item['data'],
          'quantity': 1,
          'totalPrice': item['price']
        };
      }
    }

    setState(() {
      processedItems = itemMap.values.toList();
    });
  }

  double calculateTotalPrice() {
    double totalPrice = 0;
    for (var item in processedItems) {
      totalPrice += item['totalPrice'];
    }
    return totalPrice;
  }
  double TotalPriceToPay=0.0;
  double calculateGst(double totalPrice) {
    TotalPriceToPay = (totalPrice * gstRate) + totalPrice + 5.0 ;
    return totalPrice * gstRate;
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = calculateTotalPrice();
    double gstAmount = calculateGst(totalPrice);

    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        title: Text('Price Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 300,
                child: ListView.builder(
                  itemCount: processedItems.length,
                  itemBuilder: (context, index) {
                    final item = processedItems[index];
                    return ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
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
                      title: Center(
                        child: Text('Quantity: ${item['quantity']}'),
                      ),
                      trailing: Text('\$${item['totalPrice']}'),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 300,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Price Details',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          fontFamily: 'LibreBaskerville',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Item Price',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'LibreBaskerville',
                            ),
                          ),
                          Text(
                            '\$$totalPrice',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              fontFamily: 'LibreBaskerville',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'GST',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'LibreBaskerville',
                            ),
                          ),
                          Text(
                            '\$${gstAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              fontFamily: 'LibreBaskerville',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Handling Charge',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'LibreBaskerville',
                            ),
                          ),
                          Text(
                            '\$5.00',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              fontFamily: 'LibreBaskerville',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Delevery Charge',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'LibreBaskerville',
                              ),
                            ),
                          ),
                          Text(
                            '\$30',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              fontFamily: 'LibreBaskerville',
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.black,
                              decorationThickness: 2.0,
                            ),
                          ),
                          SizedBox(width: 10,),
                          Text('Free Delevery',style: TextStyle(color: Colors.green,fontFamily:'LibreBaskerville',fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.black,
                            thickness: 2,
                            indent: 10,
                            endIndent: 10, // Adjust to set spacing before the text
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Price',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'LibreBaskerville',
                            ),
                          ),
                          Text(
                            '\$${TotalPriceToPay}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              fontFamily: 'LibreBaskerville',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Payment Modes',style: TextStyle(
                fontSize: 20,
                fontFamily: 'LibreBaskerville',
                decoration: TextDecoration.underline,
                decorationThickness: 2,
                decorationColor: Colors.deepPurpleAccent
              ),),
            ),
            SizedBox(height: 20,),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              child:Row(
                children: [
                  Expanded(
                      child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        width: 100,
                        child: Image.asset('assets/image/payPal.png'),
                        ),
                      ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        width: 100,
                        child: Image.asset('assets/image/visa.png'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        width: 100,
                        child: Image.asset('assets/image/amazonPay.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              child:Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        width: 100,
                        child: Image.asset('assets/image/gpay.png'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        width: 100,
                        child: Image.asset('assets/image/ppay.png'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        width: 100,
                        child: Image.asset('assets/image/paytm.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              child:Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        width: 100,
                        child: Image.asset('assets/image/creditCard.png',fit: BoxFit.cover,),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        width: 100,
                        child: Image.asset('assets/image/upi.png'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        width: 100,
                        child: Image.asset('assets/image/rupay.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                margin: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.offline_bolt),
                        SizedBox(width: 15),
                        Text(
                          'Next Gen Plus Coins',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'LibreBaskerville'),
                        )
                      ],
                    ),
                    Icon(Icons.keyboard_arrow_right)
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                margin: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.money),
                        SizedBox(width: 15),
                        Text(
                          'Case On Delevery',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'LibreBaskerville'),
                        )
                      ],
                    ),
                    Icon(Icons.keyboard_arrow_right)
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                margin: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.comment_bank),
                        SizedBox(width: 15),
                        Text(
                          'Pay Through EMI',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'LibreBaskerville'),
                        )
                      ],
                    ),
                    Icon(Icons.keyboard_arrow_right)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

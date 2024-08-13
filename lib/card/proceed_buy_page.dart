import 'dart:convert';
import '../Address/address_data.dart';
import '../task8_helper/task8_db_helper.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class BuyPage extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final String additionalString;

  const BuyPage({super.key, required this.items, required this.additionalString});

  @override
  State<BuyPage> createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  List<Map<String, dynamic>> processedItems = [];
  double gstRate = 0.02; //gst

  @override
  void initState() {
    super.initState();
    processItems();
    querySpecificUser(widget.additionalString);
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

  double overalPrice = 0.0;
  double TotalPrice = 0.0;

  double calculateGst(double totalPrice) {
    overalPrice =
        (totalPrice * gstRate) + totalPrice + 5.0; //calculate overal price
    if (overalPrice >= 100) {
      TotalPrice = overalPrice;
    } else {
      TotalPrice = overalPrice + 5;
    }
    return totalPrice * gstRate;
  }

  void _notAvalable() {
    showDialog(
        context: context,
        builder: (BuildContext contex) {
          return AlertDialog(
            backgroundColor: Colors.deepOrange,
            title: Text('\"ERROR\"'),
            content: Text('This Payment Method Is Not Avalable Yat...'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(contex).pop();
                  },
                  child: Text('Cancel'))
            ],
          );
        });
  }

  //dialog for payment method
  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Map<int, bool> _selectedItems = {};
        return StatefulBuilder(
          builder: (context, setState) {
            void _toggleSelection(int index) {
              setState(() {
                _selectedItems.forEach((key, value) {
                  _selectedItems[key] = false; // Deselect all items
                });
                _selectedItems[index] = true; // Select the tapped item
              });
            }
            bool _isAnyItemSelected() {
              return _selectedItems.values.any((selected) => selected);
            }

            return AlertDialog(
              title: Text('Select Payment Method'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    //first row
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _toggleSelection(0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    border: _selectedItems[0] == true
                                        ? Border.all(
                                            color: Colors.black, width: 2)
                                        : null,
                                  ),
                                  child: Image.asset('assets/image/payPal.png'),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _toggleSelection(1),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    border: _selectedItems[1] == true
                                        ? Border.all(
                                            color: Colors.black, width: 2)
                                        : null,
                                  ),
                                  child: Image.asset('assets/image/visa.png'),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _toggleSelection(2),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    border: _selectedItems[2] == true
                                        ? Border.all(
                                            color: Colors.black, width: 2)
                                        : null,
                                  ),
                                  child:
                                      Image.asset('assets/image/amazonPay.png'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Second Row
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _toggleSelection(3),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    border: _selectedItems[3] == true
                                        ? Border.all(
                                            color: Colors.black, width: 2)
                                        : null,
                                  ),
                                  child: Image.asset('assets/image/gpay.png'),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _toggleSelection(4),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    border: _selectedItems[4] == true
                                        ? Border.all(
                                            color: Colors.black, width: 2)
                                        : null,
                                  ),
                                  child: Image.asset('assets/image/ppay.png'),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _toggleSelection(5),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    border: _selectedItems[5] == true
                                        ? Border.all(
                                            color: Colors.black, width: 2)
                                        : null,
                                  ),
                                  child: Image.asset('assets/image/paytm.png'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Third Row
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _toggleSelection(6),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    border: _selectedItems[6] == true
                                        ? Border.all(
                                            color: Colors.black, width: 2)
                                        : null,
                                  ),
                                  child: Image.asset(
                                      'assets/image/creditCard.png',
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _toggleSelection(7),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    border: _selectedItems[7] == true
                                        ? Border.all(
                                            color: Colors.black, width: 2)
                                        : null,
                                  ),
                                  child: Image.asset('assets/image/upi.png'),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _toggleSelection(8),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    border: _selectedItems[8] == true
                                        ? Border.all(
                                            color: Colors.black, width: 2)
                                        : null,
                                  ),
                                  child: Image.asset('assets/image/rupay.png'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Next Gen Plus Coins Row
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => _toggleSelection(9),
                        child: Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: _selectedItems[9] == true
                                ? Border.all(color: Colors.black, width: 2)
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.offline_bolt),
                                  SizedBox(width: 15),
                                  Text(
                                    'Next Gen Plus Coins',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'LibreBaskerville',
                                    ),
                                  ),
                                ],
                              ),
                              Icon(Icons.keyboard_arrow_right),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Case On Delivery Row
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => _toggleSelection(10),
                        child: Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: _selectedItems[10] == true
                                ? Border.all(color: Colors.black, width: 2)
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.money),
                                  SizedBox(width: 15),
                                  Text(
                                    'Case On Delivery',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'LibreBaskerville',
                                    ),
                                  ),
                                ],
                              ),
                              Icon(Icons.keyboard_arrow_right),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Pay Through EMI Row
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => _toggleSelection(11),
                        child: Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: _selectedItems[11] == true
                                ? Border.all(color: Colors.black, width: 2)
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.comment_bank),
                                  SizedBox(width: 15),
                                  Text(
                                    'Pay Through EMI',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'LibreBaskerville',
                                    ),
                                  ),
                                ],
                              ),
                              Icon(Icons.keyboard_arrow_right),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                if (_isAnyItemSelected())
                  ElevatedButton(
                    onPressed: () {
                      if (_selectedItems[9] == true || _selectedItems[11] == true) {
                        _notAvalable();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Payment Methord Not Avalable Yat...')),
                        );
                      }
                      else if(_selectedItems[10] == true){
                        showProcessingDialogCaseOnDelevery(context);
                      }
                      else {
                        showProcessingDialog(context);
                      }
                    },
                    child: Text('Pay'),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  //dialog for done payment
  void showProcessingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Initial Circular Progress Indicator
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Processing...'),
              ],
            ),
          ),
        );
      },
    );
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pop(); // Close the processing dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Green Circle with Done Icon
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: Duration(seconds: 1),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Payment Successful',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '\$${TotalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Keep shopping....',
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Icon(
                        Icons.emoji_emotions,
                        color: Colors.deepPurpleAccent,
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      Navigator.of(context).pop(); // Close the next dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyHomePage(
                            title: 'Home Page',
                            additionalString: widget.additionalString,
                            login: true,
                          ),
                        ),
                      );
                    },
                    child: const Text('Done'),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  //dialog for caseOnDelevery sucessfully
  void showProcessingDialogCaseOnDelevery(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Initial Circular Progress Indicator
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Processing...'),
              ],
            ),
          ),
        );
      },
    );
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pop(); // Close the processing dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Green Circle with Done Icon
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: Duration(seconds: 1),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Order Placed Successfully',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Keep shopping....',
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Icon(
                        Icons.emoji_emotions,
                        color: Colors.deepPurpleAccent,
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      Navigator.of(context).pop(); // Close the next dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyHomePage(
                          title: 'Home Page',
                          additionalString: widget.additionalString,
                          login: true,
                        ),
                        ),
                      );
                    },
                    child: const Text('Done'),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }


  //address
  final dbhelper = task8_db.instance;
  List<Map<String, dynamic>> user = [];
  Map<String, dynamic> address1 = {};
  Map<String, dynamic> address2 = {};
  Map<String, dynamic> address3 = {};

  int? selectedAddress;

  void querySpecificUser(String id) async {
    user = await dbhelper.querySpacific(id);
    if (user.isNotEmpty) {
      address1 = jsonDecode(user[0]['Adress1']);
      address2 = jsonDecode(user[0]['Adress2']);
      address3 = jsonDecode(user[0]['Adress3']);
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _dialog(String tittle, String buttonName, int no) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        TextEditingController nameController = TextEditingController();
        TextEditingController cityController = TextEditingController();
        TextEditingController pinController = TextEditingController();
        TextEditingController postController = TextEditingController();
        TextEditingController houseNameController = TextEditingController();
        TextEditingController landmarkController = TextEditingController();
        return AlertDialog(
          title: Text(tittle),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Enter your Name',
                        suffixIcon: Icon(
                          Icons.man,
                          color: Colors.cyan,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: cityController,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Enter your city Name',
                        suffixIcon: Icon(
                          Icons.location_city,
                          color: Colors.cyan,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: pinController,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Enter your pin-code',
                        suffixIcon: Icon(
                          Icons.pin,
                          color: Colors.cyan,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: postController,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Enter your Post Station',
                        suffixIcon: Icon(
                          Icons.compost,
                          color: Colors.cyan,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: houseNameController,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Enter your House name & Number',
                        suffixIcon: Icon(
                          Icons.house,
                          color: Colors.cyan,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: landmarkController,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Enter your Near Landmark',
                        suffixIcon: Icon(
                          Icons.account_tree_sharp,
                          color: Colors.cyan,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                var obj = AddressData(
                  name: nameController.text.toLowerCase(),
                  city: cityController.text.toLowerCase(),
                  pin: pinController.text.toLowerCase(),
                  post: postController.text.toLowerCase(),
                  houseName: houseNameController.text.toLowerCase(),
                  landmark: landmarkController.text.toLowerCase(),
                );
                Navigator.of(dialogContext).pop();
                if (nameController.text.isNotEmpty &&
                    cityController.text.isNotEmpty &&
                    pinController.text.isNotEmpty &&
                    postController.text.isNotEmpty &&
                    houseNameController.text.isNotEmpty &&
                    landmarkController.text.isNotEmpty) {
                  await dbhelper.updateSpecificUserAddress(widget.additionalString, obj, no);
                }
                querySpecificUser(widget.additionalString);
              },
              child: Text(buttonName),
            ),
          ],
        );
      },
    );
  }

  void _deleteDialog(int no){
    showDialog(
        context: context,
        builder: (BuildContext dialogContext){
          return AlertDialog(
            backgroundColor: Colors.redAccent,
            title: const Text('Warning'),
            content: const Text('Did You Want To Delete The Address'),
            actions: [
              TextButton(onPressed: (){
                Navigator.of(dialogContext).pop();
              }, child: const Text('Cancel')),
              TextButton(onPressed: ()async{
                var obj1 = AddressData.namedConstructor();
                Navigator.of(context).pop();
                await dbhelper.updateSpecificUserAddress(widget.additionalString, obj1, no);
                querySpecificUser(widget.additionalString);
              }, child: const Text('Delete'))
            ],
          );
        });
  }

  Widget addressWidget(Map<String, dynamic> address, int no) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1.0),
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey[350]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              child: address['name'] == null
                  ? const Center(
                child: Text(
                  'Address is not saved',
                  style: TextStyle(
                    fontFamily: 'LibreBaskerville',
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              )
                  : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Name: ${address['name']}\nCity: ${address['city']}\nPin: ${address['pin']}\nPost: ${address['post']}\nHouse Name: ${address['houseName']}\nLandmark: ${address['landmark']}',
                  style: const TextStyle(
                    fontFamily: 'LibreBaskerville',
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            address['name'] == null
                ? Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    _dialog('Add Address', 'Add', no);
                  },
                  child: const Text('Add'),
                ),
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ElevatedButton(
                    onPressed: (){
                      _deleteDialog(no);
                    },
                    child: const Text('Delete'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _dialog('Edit Address', 'Edit', no);
                    },
                    child: const Text('Edit'),
                  ),
                ),
              ],
            ),
            RadioListTile(
              value: no,
              groupValue: selectedAddress,
              onChanged: (int? value) {
                if(address['name'] == null){
                  setState(() {
                    selectedAddress = null;
                  });
                }else{
                  setState(() {
                    selectedAddress = no;
                  });
                }

              },
              title: const Text('Select this address'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = calculateTotalPrice();
    double gstAmount = calculateGst(totalPrice);
    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        title: const Text('Price Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                shrinkWrap: true, // This makes the ListView take only the space it needs
                physics: NeverScrollableScrollPhysics(), // Disables ListView's own scrolling
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 330,
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
                          overalPrice >= 100
                              ? Row(
                                  children: [
                                    Text(
                                      '\$5',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        fontFamily: 'LibreBaskerville',
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor: Colors.black,
                                        decorationThickness: 2.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Free Delevery',
                                      style: TextStyle(
                                          color: Colors.green[700],
                                          fontFamily: 'LibreBaskerville',
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )
                              : Text(
                                  '\$5',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    fontFamily: 'LibreBaskerville',
                                  ),
                                )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.black,
                            thickness: 2,
                            indent: 10,
                            endIndent:
                                10, // Adjust to set spacing before the text
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
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
                            '\$${TotalPrice.toStringAsFixed(2)}',
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
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                            onPressed: () {
                              if(selectedAddress==null){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Address Is Not Selected Scroll Down And Select The Address')),
                                );
                              }else{
                                _showCustomDialog(context);
                              }
                            },
                            child: Text('Continue payment')),
                      ),
                    )
                  ],
                ),
              ),
            ),
            ExpansionTile(
              title: const Text(
                'Address 1',
                style: TextStyle(
                  fontFamily: 'LibreBaskerville',
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              children: [addressWidget(address1, 1)],
            ),
            ExpansionTile(
              title: const Text(
                'Address 2',
                style: TextStyle(
                  fontFamily: 'LibreBaskerville',
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              children: [addressWidget(address2, 2)],
            ),
            ExpansionTile(
              title: const Text(
                'Address 3',
                style: TextStyle(
                  fontFamily: 'LibreBaskerville',
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              children: [addressWidget(address3, 3)],
            ),
          ],
        ),
      ),
    );
  }
}
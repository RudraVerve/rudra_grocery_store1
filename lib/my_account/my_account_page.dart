import 'dart:convert';

import 'package:flutter/material.dart';

import '../Address/address_data.dart';
import '../WishList/wishListPage.dart';
import '../main.dart';
import '../myOrders/orders.dart';
import '../task8_helper/login_page.dart';
import '../task8_helper/task8_db_helper.dart';
import 'About_us_page.dart';
import 'Help_center.dart';

class MyAccount extends StatefulWidget {
  final String additionalString;

  MyAccount({super.key, this.additionalString = ''});

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  void initState() {
    super.initState();
    querySpecificUser(widget.additionalString);
  }

  final dbhelper = task8_db.instance;
  List<Map<String, dynamic>> user = [];
  Map<String, dynamic> address1 = {};
  Map<String, dynamic> address2 = {};
  Map<String, dynamic> address3 = {};

  void querySpecificUser(String id) async {
    user = await dbhelper.querySpacific(id);
    if (user.isNotEmpty) {
      address1 = jsonDecode(user[0]['Adress1']);
      address2 = jsonDecode(user[0]['Adress2']);
      address3 = jsonDecode(user[0]['Adress3']);
    }
    setState(() {});
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
                Navigator.of(dialogContext).pop();
                if (nameController.text.isNotEmpty &&
                    cityController.text.isNotEmpty &&
                    pinController.text.isNotEmpty &&
                    postController.text.isNotEmpty &&
                    houseNameController.text.isNotEmpty &&
                    landmarkController.text.isNotEmpty) {
                  await dbhelper.updateSpecificUserAddress(
                      widget.additionalString, obj, no);
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

  void _deleteDialog(int no) {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            backgroundColor: Colors.redAccent,
            title: const Text('Warning'),
            content: const Text('Did You Want To Delete The Address'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () async {
                    var obj1 = AddressData.namedConstructor();
                    Navigator.of(dialogContext).pop();
                    Navigator.of(dialogContext).pop();
                    await dbhelper.updateSpecificUserAddress(
                        widget.additionalString, obj1, no);
                    querySpecificUser(widget.additionalString);
                  },
                  child: const Text('Delete'))
            ],
          );
        });
  }

  Widget addressWidget(Map<String, dynamic> address, int no, String addNo) {
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
                  ? Center(
                      child: Text(
                        '${addNo} is not saved',
                        style: const TextStyle(
                          fontFamily: 'LibreBaskerville',
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        'Name: ${address['name']}',
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
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        onPressed: () {
                          _dialog('Add Address', 'Add', no);
                        },
                        child: const Text('Add'),
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
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
          ],
        ),
      ),
    );
  }

  void addressDialog() {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Addresses'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  addressWidget(address1, 1, 'Address 1'),
                  addressWidget(address2, 2, 'Address 2'),
                  addressWidget(address3, 3, 'Address 3'),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Cancel'))
            ],
          );
        });
  }

  void notAvailableDialog() {
    showDialog(
        context: context,
        builder: (BuildContext buildCondtext) {
          return AlertDialog(
            backgroundColor: Colors.greenAccent,
            title: const Text('Alert'),
            content: const Text(
                'This Content is not available yet plz use other functionality'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(buildCondtext).pop();
                  },
                  child: const Text('Cancel'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 9.0, top: 4),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NextGenDescriptionPage(),
                  ),
                );
              },
              child: Column(
                children: [
                  ClipOval(
                    child: SizedBox(
                      width: 45,
                      height: 35,
                      child: Image.asset(
                        'assets/image/about_us.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Text('About Us')
                ],
              ),
            ),
          )
        ],
        title: Text(widget.additionalString),
        backgroundColor: Colors.teal[100],
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false, // Removes the back button
      ),
      backgroundColor: Colors.teal[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 150,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OrdersPage(userId: user[0]['id']),
                              ),
                            );
                          },
                          child: Container(
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.black, // Border color
                                width: 1.0, // Border width
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Icon(Icons.shopping_bag,
                                    color: Colors.blue),
                                const Text(
                                  'Orders',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'PlaywriteMX'),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => wishListPage(
                                    additionalString: widget.additionalString),
                              ),
                            );
                          },
                          child: Container(
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.black, // Border color
                                width: 1.0, // Border width
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Icon(Icons.favorite, color: Colors.red),
                                const Text(
                                  'WishList',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'PlaywriteMX'),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 50,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.black, // Border color
                              width: 1.0, // Border width
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Icon(Icons.card_giftcard,
                                  color: Colors.redAccent),
                              const Text(
                                'Coupons',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'PlaywriteMX'),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HelpCenterpage(),
                              ),
                            );
                          },
                          child: Container(
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.black, // Border color
                                width: 1.0, // Border width
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Icon(Icons.headset_mic_outlined,
                                    color: Colors.blue),
                                const Text(
                                  'Help Center',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'PlaywriteMX'),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Acount Settings',
                    style: TextStyle(
                        fontFamily: 'LibreBaskerville',
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  )),
            ),
            //next gen plus
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: notAvailableDialog,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.offline_bolt),
                          const SizedBox(width: 15),
                          const Text(
                            'Next Gen Plus',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'LibreBaskerville'),
                          )
                        ],
                      ),
                      const Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                ),
              ),
            ),
            //Edit Account
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: notAvailableDialog,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.person),
                          const SizedBox(width: 15),
                          const Text(
                            'Edit Account',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'LibreBaskerville'),
                          )
                        ],
                      ),
                      const Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                ),
              ),
            ),
            //Saved Card & Wallet
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: notAvailableDialog,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.account_balance_wallet),
                          const SizedBox(width: 15),
                          const Text(
                            'Saved Card & Wallet',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'LibreBaskerville'),
                          )
                        ],
                      ),
                      const Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                ),
              ),
            ),
            //Save Address
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                margin: const EdgeInsets.all(8),
                child: InkWell(
                  onTap: () {
                    //in process
                    addressDialog();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.location_on),
                          const SizedBox(width: 15),
                          const Text(
                            'Save Address',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'LibreBaskerville'),
                          )
                        ],
                      ),
                      const Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                ),
              ),
            ),
            //Select Language
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: notAvailableDialog,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.language),
                          const SizedBox(width: 15),
                          const Text(
                            'Select Language',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'LibreBaskerville'),
                          )
                        ],
                      ),
                      const Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                ),
              ),
            ),
            //Notification Setting
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: notAvailableDialog,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.notifications_active),
                          const SizedBox(width: 15),
                          const Text(
                            'Notification Setting',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'LibreBaskerville'),
                          )
                        ],
                      ),
                      const Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                ),
              ),
            ),
            //Refer & earn >>>> Earn Coins
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Refer & Earn
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black, // Border color
                          width: 1.0, // Border width
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text('Refer & Earn',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          IconButton(
                              onPressed: () {}, icon: const Icon(Icons.share))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  //Earn Coins
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black, // Border color
                          width: 1.0, // Border width
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            'Earn Coins',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.currency_bitcoin_sharp))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            //Log In With Another Account
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.cyan,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black, // Border color
                      width: 1.0, // Border width
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Log In With Another Acount',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'LibreBaskerville'),
                    ),
                  ),
                ),
              ),
            ),
            //Log Out
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(
                        title: 'Home page',
                        additionalString: '',
                        login: false,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.cyan,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black, // Border color
                      width: 1.0, // Border width
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Log Out',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'LibreBaskerville'),
                    ),
                  ),
                ),
              ),
            )
          ],
        ), // Empty body
      ),
    );
  }
}
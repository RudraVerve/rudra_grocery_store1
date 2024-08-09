import 'dart:convert';
import 'package:flutter/material.dart';
import '../task8_helper/task8_db_helper.dart';
import 'address_data.dart';

class Address extends StatefulWidget {
  final String additionalString;

  const Address({super.key, required this.additionalString});

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
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
                Navigator.of(context).pop();
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

  Widget _addressWidget(Map<String, dynamic> address, int no) {
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
    return Scaffold(
      backgroundColor: Colors.teal[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            ExpansionTile(
              title: const Text(
                'Address 1',
                style: TextStyle(
                  fontFamily: 'LibreBaskerville',
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              children: [_addressWidget(address1, 1)],
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
              children: [_addressWidget(address2, 2)],
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
              children: [_addressWidget(address3, 3)],
            ),
          ],
        ),
      ),
    );
  }
}
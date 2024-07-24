import 'dart:convert';
import 'package:flutter/material.dart';
import 'address_data.dart';
import '../task8_helper/task8_db_helper.dart';

class Address extends StatefulWidget {
  final additionalString;
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
  Map<String, dynamic> address1={};
  Map<String, dynamic> address2={};
  Map<String, dynamic> address3={};
  void querySpecificUser(String id) async {
    user = await dbhelper.querySpacific(id);
    address1= jsonDecode(user[0]['Adress1']);
    address2= jsonDecode(user[0]['Adress2']);
    address3= jsonDecode(user[0]['Adress3']);
    print(address1);
    setState(() {});
  }
  void _Dialog(String Titel, String buttonName, int no){
    showDialog (context: context, builder:(BuildContext dialogContext){
      TextEditingController nameController = TextEditingController();
      TextEditingController cityController = TextEditingController();
      TextEditingController pinController = TextEditingController();
      TextEditingController postController = TextEditingController();
      TextEditingController houseNameController = TextEditingController();
      TextEditingController landmarkController = TextEditingController();
      return AlertDialog(
        title: Text(Titel),
        content: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller:nameController,
                    decoration: InputDecoration(
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
                    controller:cityController,
                    decoration: InputDecoration(
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
                    controller:pinController,
                    decoration: InputDecoration(
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
                    controller:postController,
                    decoration: InputDecoration(
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
                    controller:houseNameController,
                    decoration: InputDecoration(
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
                    controller:landmarkController,
                    decoration: InputDecoration(
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
          TextButton(onPressed: (){
            Navigator.of(dialogContext).pop();
          }, child: Text('Cancel')),
          TextButton(onPressed: () async{
            var obj = AddressData(
              name: nameController.text.toLowerCase(),
              city: cityController.text.toLowerCase(),
              pin: pinController.text.toLowerCase(),
              post: postController.text.toLowerCase(),
              houseName: houseNameController.text.toLowerCase(),
              landmark: landmarkController.text.toLowerCase(),
            );
            if(nameController.text.isNotEmpty && cityController.text.isNotEmpty && pinController.text.isNotEmpty && postController.text.isNotEmpty && houseNameController.text.isNotEmpty && landmarkController.text.isNotEmpty){
              await dbhelper.updateSpecificUserAddress1(widget.additionalString,obj,no);
            }
            Navigator.of(dialogContext).pop();
            setState(() {
              querySpecificUser(widget.additionalString);
            });
          }, child: Text(buttonName))
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 146,
                      child:address1['name']== null ? Center(child: Text('Address 1 Is Not Save',style: TextStyle(fontFamily: 'LibreBaskerville',fontWeight: FontWeight.bold,fontSize: 17),)) : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(' Name : ${address1['name']}\n City :${address1['city']}\n Pin :${address1['pin']}\n Post :${address1['post']}\n HouseName :${address1['city']}\n LandMark :${address1['landmark']}',style: TextStyle(fontFamily: 'LibreBaskerville',fontWeight: FontWeight.bold,fontSize: 17),),
                      ),
                    ),
                    address1['name']==null ?
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(onPressed: (){
                              _Dialog('Add Address 1','Add' ,1);
                          }, child: Text('Add'))
                      ),
                    ) :
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ElevatedButton(onPressed: ()async{
                            var obj1 = AddressData.namedConstructor();
                            await dbhelper.updateSpecificUserAddress1(widget.additionalString,obj1,1);
                            querySpecificUser(widget.additionalString);
                          }, child: Text('Delete')),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ElevatedButton(onPressed: (){
                            _Dialog('Edit Address 1','Edit',1);
                          }, child: Text('Edit')),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 146,
                      child:address2['name']== null ? Center(child: Text('Address 2 Is Not Save',style: TextStyle(fontFamily: 'LibreBaskerville',fontWeight: FontWeight.bold,fontSize: 17),)) : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(' Name : ${address2['name']}\n City :${address2['city']}\n Pin :${address2['pin']}\n Post :${address2['post']}\n HouseName :${address2['city']}\n LandMark :${address2['landmark']}',style: TextStyle(fontFamily: 'LibreBaskerville',fontWeight: FontWeight.bold,fontSize: 17),),
                      ),
                    ),
                    address2['name']==null ?
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(onPressed: (){
                              _Dialog('Add Address 2','Add' ,2);
                          }, child: Text('Add'))
                      ),
                    ) :
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ElevatedButton(onPressed: ()async{
                            var obj1 = AddressData.namedConstructor();
                            await dbhelper.updateSpecificUserAddress1(widget.additionalString,obj1,2);
                            querySpecificUser(widget.additionalString);
                          }, child: Text('Delete')),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ElevatedButton(onPressed: (){
                            _Dialog('Edit Address 2','Edit',2);
                          }, child: Text('Edit')),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 146,
                      child:address3['name']== null ? Center(child: Text('Address 3 Is Not Save',style: TextStyle(fontFamily: 'LibreBaskerville',fontWeight: FontWeight.bold,fontSize: 17),)) : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(' Name : ${address3['name']}\n City :${address3['city']}\n Pin :${address3['pin']}\n Post :${address3['post']}\n HouseName :${address3['city']}\n LandMark :${address3['landmark']}',style: TextStyle(fontFamily: 'LibreBaskerville',fontWeight: FontWeight.bold,fontSize: 17),),
                      ),
                    ),
                    address3['name']==null ?
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(onPressed: (){
                              _Dialog('Add Address 3','Add' ,3);
                          }, child: Text('Add'))
                      ),
                    ) :
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ElevatedButton(onPressed: ()async{
                            var obj1 = AddressData.namedConstructor();
                            await dbhelper.updateSpecificUserAddress1(widget.additionalString,obj1,3);
                            querySpecificUser(widget.additionalString);
                          }, child: Text('Delete')),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ElevatedButton(onPressed: (){
                            _Dialog('Edit Address 3','Edit',3);
                          }, child: Text('Edit')),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}

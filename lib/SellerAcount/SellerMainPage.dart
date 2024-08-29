import 'package:flutter/material.dart';
import '../task8_helper/login_page.dart';
import 'SellerHomePage/SellerHomePage.dart';

class SellerMainPage extends StatefulWidget {
  final bool login;
  const SellerMainPage({super.key, required this.login});

  @override
  State<SellerMainPage> createState() => _SellerMainPageState();
}

class _SellerMainPageState extends State<SellerMainPage> {

  int selectedIndex = 0;// Default to Home tab
  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Seller Account',
          )
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
        backgroundColor: Colors.lightGreenAccent,
      ),
      body: Container(
          child: selectedIndex == 0
              ? const SellerHomePage()
              : Padding(
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
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Log In With Another Account',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'LibreBaskerville'),
                  ),
                ),
              ),
            ),
          ),
      )
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'WishList/wishListPage.dart';
import 'app_open_page.dart';
import 'homePage/homePage.dart';
import 'my_account/my_account_page.dart';
import 'task8_helper/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    super.key,
    required this.title,
    required this.additionalString,
    required this.login,
  });

  final String title;
  final String additionalString;
  final bool login;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int selectedIndex = 0;// Default to Home tab
  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (index == 2 && !widget.login) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
      );
    }

    if (index == 1 && !widget.login){
      _showLoginDialog();
    }
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Required'),
          content: const Text('Please login to add items to the cart.'),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel')),
            ElevatedButton(
              child: const Text('Login'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'WishList',
          ),
          widget.login
              ? const BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: 'Account',
                )
              : const BottomNavigationBarItem(
                  icon: Icon(Icons.login),
                  label: 'Login',
                ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.teal,
        onTap: _onItemTapped,
      ),
      body: Container(
          child: selectedIndex == 0
              ? HomePage(additionalString: widget.additionalString)
              : selectedIndex == 1
                  ? widget.login
                      ? wishListPage(additionalString: widget.additionalString)
                      : const Center(
                          child: Text(
                          'First You Have To Log In\n        To See The WishList',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'LibreBaskerville'),
                        ))
                      : widget.login
                          ? MyAccount(additionalString: widget.additionalString)
                          : const Text('')),
    );
  }
}
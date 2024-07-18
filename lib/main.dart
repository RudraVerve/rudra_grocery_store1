import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_open_page.dart';
import 'card/cardPage.dart';
import 'homePage/homePage.dart';
import 'my_account/my_account_page.dart';
import 'task8_helper/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(MaterialApp(
    home: SplashScreen(),
    debugShowCheckedModeBanner: false,
  ));
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
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        additionalString: '',
        login: false,
      ),
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
  int _selectedIndex = 0; // Default to Home tab

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 4 && !widget.login) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
      );
    }

    if (index == 1 && !widget.login) {
      _showLoginDialog();
    }
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Required'),
          content: Text('Please login to add items to the cart.'),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel')),
            ElevatedButton(
              child: Text('Login'),
              onPressed: () {
                Navigator.push(
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
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Card',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Daily Use',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Address',
          ),
          widget.login
              ? BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: 'Account',
                )
              : BottomNavigationBarItem(
                  icon: Icon(Icons.login),
                  label: 'Login',
                ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
      body: Container(
        child: _selectedIndex == 0
            ? HomePage(additionalString: widget.additionalString)
            : _selectedIndex == 1
                ? widget.login
                    ? card_page(additionalString: widget.additionalString)
                    : Center(
                        child: Text('First You Have To Log In To See The Card'))
                : _selectedIndex == 2
                    ? Center(child: Text('Daily Use Screen'))
                    : _selectedIndex == 3
                        ? Center(child: Text('Location'))
                        : widget.login
                            ? MyAccount(
                                additionalString: widget.additionalString)
                            : Text(''),
      ),
    );
  }
}

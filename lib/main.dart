import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'task8_helper/homePage.dart';
import 'task8_helper/login_page.dart';
import 'task8_helper/task8_db_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //cupertinoapp
      title: 'My app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
          title: 'Flutter Demo Home Page', additionalString: '', login: false),
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
  final dbhelper = task8_db.instance;
  List<Map<String, dynamic>> user = [];

  void _fachUser(String User) async {
    try {
      user = await dbhelper.querySpacific(User);
      setState(() {});
    } catch (e) {
      print('error to fatch');
    }
  }

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
            label: 'login',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
      body: Center(
        child: _selectedIndex == 0
            ? HomePage()
            : _selectedIndex == 1
            ? Text('Card Screen')
            : _selectedIndex == 2
            ? Text('Daily Use Screen')
            : _selectedIndex == 3
            ? Text('Location')
            : widget.login
            ? Text('Welcome ${widget.additionalString}')
            : Text(''),
      ),
    );
  }
}
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';
import 'task8_db_helper.dart';

class signUp extends StatefulWidget {
  @override
  _signup createState() => _signup();
}

class _signup extends State<signUp> {
  final _key2 = GlobalKey<FormState>();
  TextEditingController mailSignup = TextEditingController();
  TextEditingController userIdSignup = TextEditingController();
  TextEditingController PassWordSignup = TextEditingController();
  TextEditingController RePassWordSignup = TextEditingController();
  TextEditingController questainSignup = TextEditingController();
  TextEditingController questainSignup2 = TextEditingController();

  bool show = false;
  bool show2 = false;
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    fetchAllRows();
  }

  void togleShow1() {
    setState(() {
      show = !show;
    });
  }

  void togleShow2() {
    setState(() {
      show2 = !show2;
    });
  }

  String? validateEmail(String? value) {
    const emailPattern = r'^[^@\s]+@[^@\s]+\.[^@\s]+$';
    final regExp = RegExp(emailPattern);

    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.length < 6 || value.length > 20) {
      return 'Password must be between 6 to 20 characters';
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    return null;
  }

  void _Dialog(String worning) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.amber,
          title: Text('Worning', style: TextStyle(color: Colors.redAccent)),
          content: Text('${worning}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  final dbhelper = task8_db.instance;
  List<Map<String, dynamic>> rows = [];

  Future<void> fetchAllRows() async {
    try {
      rows = await dbhelper.queryall();
      setState(() {});
      print("Fetched rows: $rows");
    } catch (e) {
      print("Error fetching rows: $e");
    }
  }

  Future<void> handleSignUp() async {
    if (_key2.currentState?.validate() ?? false) {
      if (mailSignup.text.isNotEmpty &&
          userIdSignup.text.isNotEmpty &&
          PassWordSignup.text.isNotEmpty &&
          RePassWordSignup.text.isNotEmpty &&
          questainSignup.text.isNotEmpty &&
          questainSignup2.text.isNotEmpty) {
        if (PassWordSignup.text == RePassWordSignup.text) {
          await fetchAllRows(); // Ensure the latest rows are fetched

          bool userExists =
              rows.any((user) => user['UserId'] == userIdSignup.text);

          if (userExists) {
            _Dialog('The User Already Exists. Try a unique User ID');
          } else {
            final id = await dbhelper.insert(
                mailSignup.text,
                userIdSignup.text,
                PassWordSignup.text,
                questainSignup.text,
                questainSignup2.text, []);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Well Come to Next Gen Famaly...')),
            );
            print('Inserted ID: $id');
            if (id > 0) {
              print('Sucess');
            } else {
              _Dialog('Error creating account. Please try again later.');
            }

            // Fetch rows after insertion to keep the list updated
            await fetchAllRows();
          }
        } else {
          _Dialog('Passwords do not match. Please check again.');
        }
      } else {
        _Dialog('All fields must be filled.');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fix the errors')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomCenter,
              colors: [
                Colors.cyan.withOpacity(0.8),
                Colors.deepPurple.withOpacity(0.8),
                Colors.deepOrangeAccent.withOpacity(0.8),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Create Acount to next gen',
                    style: TextStyle(
                        fontSize: 28,
                        fontFamily: 'PlaywriteMX',
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: 350,
                  child: Column(
                    children: [
                      Form(
                        key: _key2,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: mailSignup,
                                validator: validateEmail,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: 'Enter Email Id',
                                  suffixIcon: Icon(Icons.email),
                                  hintStyle: TextStyle(
                                    color: Colors
                                        .lightGreenAccent, // Set the hint text color to green
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 2),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: userIdSignup,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: 'Enter user Id',
                                  suffixIcon: Icon(Icons.account_circle),
                                  hintStyle: TextStyle(
                                    color: Colors
                                        .lightGreenAccent, // Set the hint text color to green
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 2),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: PassWordSignup,
                                validator: validatePassword,
                                keyboardType: TextInputType.text,
                                obscureText: !show,
                                decoration: InputDecoration(
                                  hintText: 'Enter user Password',
                                  suffixIcon: IconButton(
                                    icon: Icon(show
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      togleShow1();
                                    },
                                  ),
                                  hintStyle: TextStyle(
                                    color: Colors
                                        .lightGreenAccent, // Set the hint text color to green
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 2),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: RePassWordSignup,
                                keyboardType: TextInputType.text,
                                obscureText: !show2,
                                decoration: InputDecoration(
                                  hintText: 'Conform Password',
                                  suffixIcon: IconButton(
                                    icon: Icon(show2
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      togleShow2();
                                    },
                                  ),
                                  hintStyle: TextStyle(
                                    color: Colors
                                        .lightGreenAccent, // Set the hint text color to green
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 2),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: questainSignup,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: 'Your pet name',
                                  suffixIcon: Icon(Icons.pets),
                                  hintStyle: TextStyle(
                                    color: Colors
                                        .lightGreenAccent, // Set the hint text color to green
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 2),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: questainSignup2,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: 'Your favorite Subject',
                                  suffixIcon: Icon(Icons.add_chart_outlined),
                                  hintStyle: TextStyle(
                                    color: Colors
                                        .lightGreenAccent, // Set the hint text color to green
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 2),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: ElevatedButton(
                            onPressed: () async {
                              handleSignUp();
                            },
                            child: Text('Create Acount')),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Alrady have an acount?  ',
                            style: TextStyle(fontSize: 18)),
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            color: Colors.yellow,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}

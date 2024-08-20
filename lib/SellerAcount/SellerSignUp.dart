import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../task8_helper/task8_db_helper.dart';
import '../Address/address_data.dart';
import 'SelerLogin.dart';

class SellerSignUp extends StatefulWidget {
  @override
  _SellerSignUp createState() => _SellerSignUp();
}

class _SellerSignUp extends State<SellerSignUp> {
  final _key2 = GlobalKey<FormState>();
  TextEditingController sellerMailSignup = TextEditingController();
  TextEditingController sellerNameSignup = TextEditingController();
  TextEditingController sellerStoreNameSignup = TextEditingController();
  TextEditingController sellerMobileSignup = TextEditingController();
  TextEditingController sellerPassWordSignup = TextEditingController();
  TextEditingController sellerRePassWordSignup = TextEditingController();
  TextEditingController sellerQuestainSignup = TextEditingController();
  TextEditingController sellerQuestainSignup2 = TextEditingController();

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
          title: const Text('Worning', style: TextStyle(color: Colors.redAccent)),
          content: Text('${worning}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('OK'),
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
      rows = await dbhelper.queryallSeller();
      setState(() {});
      print("Fetched rows: $rows");
    } catch (e) {
      print("Error fetching rows: $e");
    }
  }

  Future<void> handleSignUp() async {
    if (_key2.currentState?.validate() ?? false) {
      if (sellerMailSignup.text.isNotEmpty &&
          sellerMobileSignup.text.isNotEmpty &&
          sellerPassWordSignup.text.isNotEmpty &&
          sellerRePassWordSignup.text.isNotEmpty &&
          sellerQuestainSignup.text.isNotEmpty &&
          sellerQuestainSignup2.text.isNotEmpty &&
          sellerStoreNameSignup.text.isNotEmpty &&
          sellerNameSignup.text.isNotEmpty) {
        if (sellerPassWordSignup.text == sellerRePassWordSignup.text) {
          await fetchAllRows(); // Ensure the latest rows are fetched

          bool userExists = rows.any((user) => user['seller_Mobile'] == sellerMobileSignup.text);

          if (userExists) {
            _Dialog('The Seller Already Exists. Try a unique User ID');
          } else {
            var obj1 = AddressData.namedConstructor();
            final id = await dbhelper.insertSeller(
                sellerMailSignup.text,
                sellerNameSignup.text,
                sellerStoreNameSignup.text,
                sellerMobileSignup.text,
                sellerPassWordSignup.text,
                sellerQuestainSignup.text,
                sellerQuestainSignup2.text,
                obj1);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Well Come to Next Gen Famaly...')),
            );
            sellerMailSignup.clear();
            sellerMobileSignup.clear();
            sellerNameSignup.clear();
            sellerStoreNameSignup.clear();
            sellerPassWordSignup.clear();
            sellerRePassWordSignup.clear();
            sellerQuestainSignup.clear();
            sellerQuestainSignup2.clear();
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
        const SnackBar(content: Text('Please fix the errors')),
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
                    Colors.white.withOpacity(0.8),
                    Colors.greenAccent.withOpacity(0.8),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Create Account To NextGen Seller',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'LibreBaskerville',
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 350,
                      child: Column(
                        children: [
                          Form(
                            key: _key2,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: sellerMailSignup,
                                    validator: validateEmail,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter Email Id',
                                      suffixIcon: Icon(Icons.email),
                                      hintStyle: TextStyle(
                                        color: Colors
                                            .black, // Set the hint text color to green
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: sellerNameSignup,
                                    keyboardType: TextInputType.name,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter Your Name',
                                      suffixIcon: Icon(Icons.person),
                                      hintStyle: TextStyle(
                                        color: Colors
                                            .black, // Set the hint text color to green
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: sellerStoreNameSignup,
                                    keyboardType: TextInputType.name,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter Store Name',
                                      suffixIcon: Icon(Icons.store),
                                      hintStyle: TextStyle(
                                        color: Colors
                                            .black, // Set the hint text color to green
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: sellerMobileSignup,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter Mobil number.',
                                      suffixIcon: Icon(Icons.phone),
                                      hintStyle: TextStyle(
                                        color: Colors
                                            .black, // Set the hint text color to green
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: sellerPassWordSignup,
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
                                      hintStyle: const TextStyle(
                                        color: Colors
                                            .black, // Set the hint text color to green
                                      ),
                                      border: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                      ),
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.green, width: 2),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: sellerRePassWordSignup,
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
                                      hintStyle: const TextStyle(
                                        color: Colors
                                            .black, // Set the hint text color to green
                                      ),
                                      border: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                      ),
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.green, width: 2),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: sellerQuestainSignup,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                      hintText: 'Your pet name',
                                      suffixIcon: Icon(Icons.pets),
                                      hintStyle: TextStyle(
                                        color: Colors
                                            .black, // Set the hint text color to green
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: sellerQuestainSignup2,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                      hintText: 'Your favorite Subject',
                                      suffixIcon: Icon(Icons.add_chart_outlined),
                                      hintStyle: TextStyle(
                                        color: Colors
                                            .black, // Set the hint text color to green
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
                            padding: const EdgeInsets.all(20),
                            child: ElevatedButton(
                                onPressed: () async {
                                  handleSignUp();
                                },
                                child: const Text('Create Acount')),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'Alrady A Seller?  ',
                                style: TextStyle(fontSize: 16)),
                            TextSpan(
                              text: 'Login',
                              style: const TextStyle(
                                color: Colors.pinkAccent,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SellerLogin(),
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
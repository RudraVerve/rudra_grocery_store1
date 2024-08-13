import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../task8_helper/login_page.dart';
import '../task8_helper/task8_db_helper.dart';
import 'SellerHomePage.dart';
import 'SellerSignUp.dart';

class SellerLogin extends StatefulWidget {
  @override
  _SellerLogin createState() => _SellerLogin();
}

class _SellerLogin extends State<SellerLogin> {
  final _key = GlobalKey<FormState>();
  bool show = false;
  bool isChecked = false;
  TextEditingController mobile = TextEditingController();
  TextEditingController passWord = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  void togleShow() {
    setState(() {
      show = !show;
    });
  }

  void _loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mobileNumber = prefs.getString('mobile');
    String? password = prefs.getString('password');
    if (mobileNumber != null && password != null) {
      setState(() {
        this.mobile.text = mobileNumber;
        this.passWord.text = password;
        this.isChecked = true;
      });
    }
  }

  void _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isChecked) {
      await prefs.setString('mobile', mobile.text);
      await prefs.setString('password', passWord.text);
    } else {
      await prefs.remove('mobile');
      await prefs.remove('password');
    }
  }

  void _toggleCheckbox(bool? value) {
    setState(() {
      isChecked = value ?? false;
      _saveCredentials();
    });
  }

  final dbhelper = task8_db.instance;
  List<Map<String, dynamic>> seller = [];

  void _fachUser(String User) async {
    try {
      seller = await dbhelper.querySpacificSeller(User);
      _validUser();
      setState(() {});
    } catch (e) {
      print('error to fatch');
    }
  }

  void _validUser() {
    if (seller.length == 0) {
      _Dialog('User Is Not Exist');
    } else {
      if (seller[0]["seller_Password"] == passWord.text) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SellerHome(),
          ),
        );
        mobile.clear();
        passWord.clear();
      } else {
        if (_key.currentState?.validate() ?? false) {
          print('Wrong pass');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Wrong password')),
          );
        }
      }
    }
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

  String? validationPass(String? value) {
    return 'You Enter Wrong Password';
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
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.greenAccent.withOpacity(0.8),
                    Colors.cyan.withOpacity(0.8),
                    Colors.orange.withOpacity(0.8),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 35),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: CircleAvatar(
                        backgroundImage: AssetImage(
                          show
                              ? 'assets/image/openEye.jpg'
                              : 'assets/image/closeEye.jpg',
                        ),
                        radius: 40,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Login To NextGen',
                      style: TextStyle(
                          fontSize: 35,
                          fontFamily: 'LibreBaskerville',
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Seller',
                      style: TextStyle(
                          fontSize: 35,
                          fontFamily: 'PlaywriteMX',
                          color: Colors.black,fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: 350,
                      child: Column(
                        children: [
                          Form(
                            key: _key,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: mobile,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        hintText: 'Enter Mobile Number',
                                        suffixIcon: Icon(Icons.account_circle),
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(0.8),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20),
                                            borderSide: BorderSide(
                                                color: Colors.black, width: 2)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20),
                                            borderSide: BorderSide(
                                              color: Colors.green,
                                            ))),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: passWord,
                                    validator: validationPass,
                                    keyboardType: TextInputType.text,
                                    obscureText: !show,
                                    decoration: InputDecoration(
                                        hintText: 'Enter user Password',
                                        suffixIcon: IconButton(
                                          icon: Icon(show
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                          onPressed: () {
                                            togleShow();
                                          },
                                        ),
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(0.8),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20),
                                            borderSide: BorderSide(
                                                color: Colors.black, width: 2)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20),
                                            borderSide: BorderSide(
                                              color: Colors.green,
                                            ))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: isChecked,
                                    onChanged: _toggleCheckbox,
                                    fillColor: MaterialStateProperty.resolveWith(
                                            (Set<MaterialState> states) {
                                          if (states.contains(MaterialState.selected)) {
                                            return Colors.blue;
                                          }
                                          return Colors.white;
                                        }),
                                    checkColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      side: BorderSide(
                                          color: Colors.white, width: 2.0),
                                    ),
                                  ),
                                  Text(
                                    'Remind me',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              TextButton(
                                child: Text(
                                  'Forget Password',
                                  style: TextStyle(
                                      fontSize: 17, fontWeight: FontWeight.w600),
                                ),
                                onPressed: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => forgetPass(),
                                  //   ),
                                  // );
                                },
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  if (mobile.text.isEmpty &&
                                      passWord.text.isEmpty) {
                                    _Dialog('You Have To Enter Ueser Id And Password');
                                  } else {
                                    _fachUser(mobile.text);
                                  }
                                },
                                child: Text('Login To Seller')),
                          ),
                        ],
                      ),
                    ), //form container
                    SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.black,
                            thickness: 2,
                            indent: 20,
                            endIndent: 10, // Adjust to set spacing before the text
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          // Adjust spacing around text
                          child: Text('or'),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.black,
                            thickness: 2,
                            indent: 10, // Adjust to set spacing after the text
                            endIndent: 20,
                          ),
                        ),
                      ],
                    ), //divider row
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  backgroundImage:
                                  AssetImage('assets/image/facebook.png'),
                                  radius: 20,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  backgroundImage:
                                  AssetImage('assets/image/google.jpeg'),
                                  radius: 20,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  backgroundImage:
                                  AssetImage('assets/image/tuit.png'),
                                  radius: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ), //docial media files
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              TextSpan(text: 'Not A Seller Yet? '),
                              TextSpan(
                                text: 'Create Seller Account',
                                style: TextStyle(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SellerSignUp(),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ), //sign up
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.all(7.0),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              TextSpan(text: 'User Login? '),
                              TextSpan(
                                text: 'Login',
                                style: TextStyle(
                                  color: Colors.purple,
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

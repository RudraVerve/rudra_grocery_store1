import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'task8_db_helper.dart';

class forgetPass extends StatefulWidget {
  _forget_pass createState() => _forget_pass();
}

class _forget_pass extends State<forgetPass> {
  final _newkey = GlobalKey<FormState>();
  TextEditingController mobile = TextEditingController();
  TextEditingController questian1 = TextEditingController();
  TextEditingController questian2 = TextEditingController();
  TextEditingController newpass = TextEditingController();
  TextEditingController renewpass = TextEditingController();

  String name = ' ? ';
  bool showQuestain = false;
  bool showUser = true;
  bool showpass = false;
  final dbhelper = task8_db.instance;
  List<Map<String, dynamic>> user = [];

  void _fachUser(String User) async {
    try {
      user = await dbhelper.querySpacific(User);
      _isUserExist();
      print(user);
      setState(() {});
    } catch (e) {
      print('error to fatch');
    }
  }

  void _isUserExist() {
    if (user.length == 0) {
      _Dialog('User Is Not Exist');
    } else {
      name = user[0]['Mobile'];
      showUser = false;
      showQuestain = true;
    }
  }

  void chackAns() async {
    if (questian1.text == user[0]['resetPass1'] &&
        questian2.text == user[0]['resetPass2']) {
      setState(() {
        showQuestain = false;
        showpass = true;
      });
    } else {
      if (questian1.text.isEmpty && questian2.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You Most Have To Fill All The Field')),
        );
      } else {
        _Dialog(
            'You Enter Wrong Answers Plese Provied Currect Answers To Continue');
      }
    }
  }

  void _Dialog(String Worning) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.amber,
          title:
          const Text('Worning', style: TextStyle(color: Colors.redAccent)),
          content: Text('${Worning}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                name = ' ? ';
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/image/forger_background.jpg'),
                  fit: BoxFit.cover,
                  opacity: 0.9),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                        'Well Come \" ${name} \"',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                          color: Colors.cyan,
                        ),
                      )),
                ),
                SizedBox(height: 100),
                SizedBox(
                  height: 450,
                  child: Column(
                    children: [
                      if (showUser) ...[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: mobile,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                hintText: 'Enter Mobile number',
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      _fachUser(mobile.text);
                                    },
                                    icon: Icon(
                                      Icons.search,
                                      color: Colors.deepPurple,
                                      size: 30,
                                    )),
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
                      if (showQuestain) ...[
                        Padding(
                          padding: EdgeInsets.all(9.0),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'What is Your Pat Name :',
                                style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                        ),
                        Padding(
                          padding:
                          EdgeInsets.only(left: 08, right: 8, bottom: 10),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: questian1,
                            decoration: InputDecoration(
                              hintText: 'Enter Your Ans...',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(9.0),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'What is Your favorite Subject :',
                                style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 08, right: 8),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: questian2,
                            decoration: InputDecoration(
                              hintText: 'Enter Your Ans...',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              chackAns();
                            },
                            child: Text('Submit'))
                      ],
                      if (showpass) ...[
                        Padding(
                          padding: EdgeInsets.all(9.0),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Enter New Password :',
                                style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                        ),
                        Padding(
                          padding:
                          EdgeInsets.only(left: 08, right: 8, bottom: 10),
                          child: Form(
                            key: _newkey,
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: newpass,
                              validator: validatePassword,
                              decoration: InputDecoration(
                                hintText: 'Enter Your New Password...',
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(9.0),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Re Enter New Password :',
                                style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 08, right: 8),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: renewpass,
                            decoration: InputDecoration(
                              hintText: 'Re Enter New password...',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () async {
                                if (newpass.text == renewpass.text) {
                                  if (_newkey.currentState?.validate() ??
                                      false) {
                                    await dbhelper.updateSpacific(
                                        mobile.text, newpass.text);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Password Update successfully!')),
                                    );
                                    setState(() {
                                      newpass.clear();
                                      renewpass.clear();
                                      mobile.clear();
                                      questian2.clear();
                                      questian1.clear();
                                      name = ' ? ';
                                      showpass = false;
                                      showUser = true;
                                    });
                                  }
                                } else {
                                  _Dialog(
                                      'Provieded Password is Not Matching to New Password');
                                }
                              },
                              child: Text('Change password')),
                        )
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 50),
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
                            text: 'Now I Want To?  ',
                            style: TextStyle(
                                fontSize: 18, color: Colors.pinkAccent)),
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
        ],
      ),
    );
  }
}
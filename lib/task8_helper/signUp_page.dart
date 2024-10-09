import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../Address/address_data.dart';
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
  TextEditingController passwordSignup = TextEditingController();
  TextEditingController rePasswordSignup = TextEditingController();
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

  void _dialog(String warning) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.amber,
          title: const Text('Warning', style: TextStyle(color: Colors.redAccent)),
          content: Text(warning),
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
      rows = await dbhelper.queryall();
      setState(() {});
    } catch (e) {
      return;
    }
  }

  Future<void> handleSignUp() async {
    if (_key2.currentState?.validate() ?? false) {
      if (mailSignup.text.isNotEmpty &&
          userIdSignup.text.isNotEmpty &&
          passwordSignup.text.isNotEmpty &&
          rePasswordSignup.text.isNotEmpty &&
          questainSignup.text.isNotEmpty &&
          questainSignup2.text.isNotEmpty) {
        if (passwordSignup.text == rePasswordSignup.text) {
          await fetchAllRows(); // Ensure the latest rows are fetched

          bool userExists =
              rows.any((user) => user['Mobile'] == userIdSignup.text);

          if (userExists) {
            _dialog('The User Already Exists. Try a unique User ID');
          } else {
            var obj1 = AddressData.namedConstructor();
            final id = await dbhelper.insert(
                mailSignup.text,
                userIdSignup.text,
                passwordSignup.text,
                questainSignup.text,
                questainSignup2.text,
                [],
                obj1,
                obj1,
                obj1);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Well Come to Next Gen Famaly...')),
            );
            mailSignup.clear();
            userIdSignup.clear();
            passwordSignup.clear();
            rePasswordSignup.clear();
            questainSignup.clear();
            questainSignup2.clear();
            if (id > 0) {
            } else {
              _dialog('Error creating account. Please try again later.');
            }
            // Fetch rows after insertion to keep the list updated
            await fetchAllRows();
          }
        } else {
          _dialog('Passwords do not match. Please check again.');
        }
      } else {
        _dialog('All fields must be filled.');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix the errors')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    // Calculate text size based on screen width or height
    double responsiveFontSize = screenWidth * 0.06; // 5% of screen width

    return Scaffold(
        body: ListView(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://img.freepik.com/premium-photo/maternity-digital-backdrop-wedding-drapery-background_877869-35160.jpg?w=360'),
                  fit: BoxFit.cover,
                ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Create Account to next gen',
                    style: TextStyle(
                        fontSize: responsiveFontSize,
                        fontFamily: 'LibreBaskerville',
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow),
                  ),
                ),
                const SizedBox(height: 30),
                Column(
                  children: [
                    Form(
                      key: _key2,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: mailSignup,
                              validator: validateEmail,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: 'Enter Email Id',
                                suffixIcon: Icon(Icons.email,color: Colors.green),
                                hintStyle: TextStyle(
                                  color: Colors
                                      .brown, // Set the hint text color to green
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
                              controller: userIdSignup,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                hintText: 'Enter Mobil number.',
                                suffixIcon: Icon(Icons.account_circle,color: Colors.green),
                                hintStyle: TextStyle(
                                  color: Colors
                                      .brown, // Set the hint text color to green
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
                              controller: passwordSignup,
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
                                  },color: Colors.green
                                ),
                                hintStyle: const TextStyle(
                                  color: Colors
                                      .brown, // Set the hint text color to green
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
                              controller: rePasswordSignup,
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
                                  },color: Colors.green
                                ),
                                hintStyle: const TextStyle(
                                  color: Colors
                                      .brown, // Set the hint text color to green
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
                              controller: questainSignup,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                hintText: 'Your pet name',
                                suffixIcon: Icon(Icons.pets,color: Colors.green),
                                hintStyle: TextStyle(
                                  color: Colors
                                      .brown, // Set the hint text color to green
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
                              controller: questainSignup2,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                hintText: 'Your favorite Subject',
                                suffixIcon: Icon(Icons.add_chart_outlined,color: Colors.green),
                                hintStyle: TextStyle(
                                  color: Colors
                                      .brown, // Set the hint text color to green
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
                Expanded(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: 'Already have an account?  ',
                                    style: TextStyle(fontSize: 18)),
                                TextSpan(
                                  text: 'Login',
                                  style: const TextStyle(
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
                      ),
                    ],
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
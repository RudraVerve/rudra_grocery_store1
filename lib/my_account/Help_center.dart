import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenterpage extends StatefulWidget {
  const HelpCenterpage({super.key});

  @override
  State<HelpCenterpage> createState() => _HelpCenterpageState();
}

class _HelpCenterpageState extends State<HelpCenterpage>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<int>? _animation;
  final List<String> _texts = [
    'Contact us on Insta...',
    'Contact us On Twitter...',
    'Contact us On Mail...',
    'Contact us On WhatsApp...',
    'Contact us On Call...',
    'Contact us On Message...',
  ];

  final List<Color> _colors = [
    Colors.red,
    Colors.black,
    Colors.brown,
    Colors.deepOrange,
    Colors.purple,
    Colors.indigo,
  ];

  int _currentTextIndex = 0;
  String _displayedText = '';
  Color _currentColor = Colors.black;
  static const int _totalDurationInSeconds = 2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: _totalDurationInSeconds),
      vsync: this,
    );

    _animation =
        IntTween(begin: 0, end: _texts[_currentTextIndex].length).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.easeInOut),
    );

    _animation!.addListener(() {
      setState(() {
        _displayedText =
            _texts[_currentTextIndex].substring(0, _animation!.value);
      });
    });

    _startTextAnimation();
  }

  void _startTextAnimation() {
    Future.doWhile(() async {
      for (int i = 0; i < _texts.length; i++) {
        if (!mounted) return false; // Check if the widget is still mounted

        setState(() {
          _currentTextIndex = i;
          _currentColor = _colors[i % _colors.length]; // Cycle through colors
        });

        _animation =
            IntTween(begin: 0, end: _texts[_currentTextIndex].length).animate(
          CurvedAnimation(parent: _controller!, curve: Curves.easeInOut),
        );

        _animation!.addListener(() {
          setState(() {
            _displayedText =
                _texts[_currentTextIndex].substring(0, _animation!.value);
          });
        });

        // Start and reset the animation
        _controller!.reset();
        _controller!.forward();

        await Future.delayed(const Duration(
            seconds:
                _totalDurationInSeconds)); // Wait for the animation to finish
      }
      return true; // Loop the animation
    });
  }

  // Helper method to build a circular image
  Widget _buildCircularImage(String imagePath, String url) {
    return ClipOval(
      child: SizedBox(
        width: 45,
        height: 45,
        child: InkWell(
          onTap: () async {
            dynamic uri = Uri.parse(url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            } else {
              return;
            }
          },
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        title: const Text("Help Center"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                '"Send Mail for Help: Because Every Great Shopping Experience Deserves a Helping Hand!"',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'LibreBaskerville'),
              ),
            ),
            // Subject box
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                maxLines: 5,
                minLines: 1,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Enter your message here...',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ),
            // Multiline message box
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                minLines: 6,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                  labelText: 'Enter your message here',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ),
            // buttons
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      TextEditingController mob = TextEditingController();
                      showDialog(
                          context: context,
                          builder: (BuildContext buildContext) {
                            return AlertDialog(
                              title: const Text('Send Contact Number'),
                              content: TextField(
                                controller: mob,
                                decoration: const InputDecoration(
                                    hintText: 'Enter mobile number',
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2, color: Colors.green))),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(buildContext).pop();
                                    },
                                    child: const Text('Cancel')),
                                TextButton(
                                  onPressed: () {
                                    if (mob.text.isNotEmpty &&
                                        mob.text.length == 10) {
                                      Navigator.of(buildContext).pop();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Call Request Send...')),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Please Enter your correct mobile number')));
                                    }
                                  },
                                  child: const Text('Send Request'),
                                ),
                              ],
                            );
                          });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor:
                          Colors.orange, // Set the background color
                    ),
                    child: const Text(
                      'Request a Call',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Message send to the seller...')),
                      );
                    },
                    child: const Text('   Send   '),
                  ),
                ],
              ),
            ),
            // Contact with us.
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCircularImage('assets/image/tut.png', "https://x.com/?lang=en"),
                    _buildCircularImage('assets/image/mail.jpg', "https://mail.google.com/mail/u/0/?tab=rm&ogbl#inbox"),
                    _buildCircularImage('assets/image/facebook.png', "https://www.facebook.com/"),
                    _buildCircularImage('assets/image/call.jpeg', "https://flutter.dev"),
                    _buildCircularImage('assets/image/whatsapp.jpeg', "https://web.whatsapp.com/"),
                    _buildCircularImage('assets/image/message.png', "https://flutter.dev"),
                  ],
                ),
              ),
            ),
            Container(
              height: 300,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image/pointing2.png'),
                  fit: BoxFit.cover, // Adjust as needed
                ),
              ),
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 70,
                    ),
                    Text(
                      _displayedText,
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: _currentColor, // Dynamic text color
                      ),
                      textAlign: TextAlign.left, // Align text to the left
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
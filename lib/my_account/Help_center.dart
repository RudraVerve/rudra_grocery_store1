import 'package:flutter/material.dart';

class HelpCenterpage extends StatefulWidget {
  const HelpCenterpage({super.key});

  @override
  State<HelpCenterpage> createState() => _HelpCenterpageState();
}

class _HelpCenterpageState extends State<HelpCenterpage> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<int>? _animation;
  final List<String> _texts = [
    'Contact us on Insta...',
    'Contact us On Twitter...',
    'Contact us On Mail...',
    'Contact us On WhatsApp',
    'Contact us On Call...',
    'Contact us On Message',
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
      duration: Duration(seconds: _totalDurationInSeconds),
      vsync: this,
    );

    _animation = IntTween(begin: 0, end: _texts[_currentTextIndex].length).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.easeInOut),
    );

    _animation!.addListener(() {
      setState(() {
        _displayedText = _texts[_currentTextIndex].substring(0, _animation!.value);
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

        _animation = IntTween(begin: 0, end: _texts[_currentTextIndex].length).animate(
          CurvedAnimation(parent: _controller!, curve: Curves.easeInOut),
        );

        _animation!.addListener(() {
          setState(() {
            _displayedText = _texts[_currentTextIndex].substring(0, _animation!.value);
          });
        });

        // Start and reset the animation
        _controller!.reset();
        _controller!.forward();

        await Future.delayed(Duration(seconds: _totalDurationInSeconds)); // Wait for the animation to finish
      }
      return true; // Loop the animation
    });
  }

  // Helper method to build a circular image
  Widget _buildCircularImage(String imagePath) {
    return ClipOval(
      child: SizedBox(
        width: 45,
        height: 45,
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover, // Ensure the image covers the entire circle
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[200],
      appBar: AppBar(
        title: Text("Help Center"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '"Send Mail for Help: Because Every Great Shopping Experience Deserves a Helping Hand!"',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, fontFamily: 'LibreBaskerville'),
              ),
            ),
            // Subject box
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                decoration: InputDecoration(
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
            // Send button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('   Send   '),
                ),
              ),
            ),
            // Contact with us.
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
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
                    SizedBox(height: 70,),
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
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCircularImage('assets/image/tuit.png'),
                    _buildCircularImage('assets/image/google.jpeg'),
                    _buildCircularImage('assets/image/facebook.png'),
                    _buildCircularImage('assets/image/call.jpeg'),
                    _buildCircularImage('assets/image/whatsapp.jpeg'),
                    _buildCircularImage('assets/image/message.png'),
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
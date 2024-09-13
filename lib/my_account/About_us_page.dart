import 'package:flutter/material.dart';

class NextGenDescriptionPage extends StatelessWidget {
  final List<Map<String, dynamic>> teamMember = [
    {
      'image': 'assets/image/feedback3.jpg',
      'name': 'Alok Bharti(The Tester)',
      'msg':
          '"Alok Bharti is our dedicated Quality Assurance Specialist. With a background in software testing and quality management, he ensures that the NextGen Online Shop application runs smoothly and meets high standards. His meticulous attention to detail helps deliver a seamless user experience."'
    },
    {
      'image': 'assets/image/feedback3.jpeg',
      'name': 'Rakash Polar(Data Base Developer)',
      'msg':
          '"Rakesh is our skilled Database Developer, responsible for designing and managing the databases that power the NextGen Online Shop. With a strong background in database architecture and optimization, he ensures data integrity, efficient access, and high performance for our application."'
    },
    {
      'image': 'assets/image/feedback.jpeg',
      'name': 'Laxmi narayan(API Developer)',
      'msg':
          '"Laxmi Narayan is our skilled REST API developer, specializing in creating robust and efficient APIs. With a solid background in backend development, he ensures seamless integration and data exchange between our application and servers, enhancing the overall functionality and performance of the NextGen Online Shop.'
    },
    {
      'image': 'assets/image/sipun.jpeg',
      'name': 'Sipun Biswal(DevOps Developer)',
      'msg':
          'Sipun is our expert DevOps developer, ensuring smooth and efficient deployment processes. With extensive experience in automation and infrastructure management, Sipun streamlines our development workflows and maintains the stability and performance of the NextGen Online Shop.'
    },
    {
      'image': 'assets/image/4673.png',
      'name': 'Mr. Barik(Devloper, CEO)',
      'msg':
          'Mr. Rudra Prakash Barik is the visionary behind the NextGen Online Shop. As the CEO and full-stack developer, he conceived the idea and led the development of the entire application. His expertise in technology and innovation drives the seamless and user-centric experience of our platform.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        title: const Text('NextGen Online Shop(About Us).'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildDescription(),
            const SizedBox(height: 20),
            _buildFeatures(),
            const SizedBox(height: 20),
            _buildCallToAction(),
            const SizedBox(height: 30),
            const Text(
              'Meet Our Team',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 115,
                  width: 110,
                  child: Image.asset('assets/image/4673.png', fit: BoxFit.fill),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Mr. Rudra Barik(CEO)',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      Text(
                        '"NextGen Online Shop is designed to transform your shopping experience with ease and innovation. Enjoy the future of shopping today!"',
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.justify,
                        maxLines: null, // Allows text to wrap to multiple lines
                        overflow: TextOverflow
                            .visible, // Ensures text is visible without truncation
                      )
                    ],
                  ),
                )
              ],
            ),
            const Text(
              'About Mr. Barik',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                decoration: TextDecoration.underline,
              ),
            ),
            const Text(
              'Mr. Rudra Prakash Barik is the visionary behind the NextGen Online Shop application. With a robust background in technology and business, he holds a degree in Computer Science Engineering from GIET UNIVERSITY. His expertise spans across software development, with specialized knowledge in mobile app development.'
              '\nAs the lead developer and CEO, Mr. Barik has been instrumental in crafting the NextGen Online Shop, blending innovative technology with a seamless shopping experience. His dedication to excellence and innovation drives the company\'s mission to revolutionize the online shopping landscape.',
              textAlign: TextAlign.justify,
              maxLines: null,
              // Allows text to wrap to multiple lines
              overflow: TextOverflow.visible,
              // Ensures text is visible without truncation
              style: TextStyle(color: Colors.brown),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: teamMember.map((client) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 50.0,
                          backgroundImage: AssetImage(client['image']),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          client['name'],
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          client['msg'],
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                              fontSize: 16.0,
                              fontStyle: FontStyle.italic,
                              color: Colors.indigo),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              color:Colors.grey,
              padding: EdgeInsets.all(10),
              child: const Center(
                child: Text(
                  '@nextGen.Copyright.2024(Rudra Barik)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Text(
        'Discover the Future of Shopping',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.teal[800],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.teal[50],
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'NextGen Online Shop is more than just an online store—'
          'it\'s your gateway to an unparalleled shopping experience. '
          'Built with cutting-edge technology and designed for convenience, '
          'our application is revolutionizing the way you shop online. '
          'Whether you\'re hunting for the latest fashion trends, high-tech gadgets, '
          'or everyday essentials, NextGen Online Shop offers a seamless and immersive '
          'shopping journey right at your fingertips.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }

  Widget _buildFeatures() {
    final features = [
      'Intuitive User Interface: Navigate with ease through our sleek and modern interface.',
      'Smart Recommendations: Leverage advanced AI to discover products tailored to your preferences.',
      'Real-Time Inventory Updates: Stay informed with live inventory tracking.',
      'Augmented Reality Try-On: Visualize how products will look in your space or on you.',
      'Seamless Checkout: Enjoy a streamlined checkout process with multiple payment options.',
      'Personalized Shopping Experience: Create wish lists and receive customized notifications.',
      'Exceptional Customer Support: Our support team is available around the clock.',
      'Eco-Friendly Initiatives: Shop with a conscience with our eco-friendly products and packaging options.',
      'Exclusive Deals and Offers: Access limited-time offers, flash sales, and exclusive promotions.',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.teal[50],
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Features That Set Us Apart:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
            const SizedBox(height: 10),
            ...features.map((feature) => ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.teal),
                  title: Text(feature, style: const TextStyle(fontSize: 16)),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildCallToAction() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Action when button is pressed
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal, // Button color
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: const Text(
          'Donate for Future of Shopping',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
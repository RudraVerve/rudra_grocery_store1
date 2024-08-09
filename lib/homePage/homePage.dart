import 'package:flutter/material.dart';
import '../task8_helper/data.dart';
import 'category_items.dart';

class HomePage extends StatefulWidget {
  final String additionalString;

  HomePage({super.key, this.additionalString = ''});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var obj = data(); //object of data

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: obj.containerData.length,
                  itemBuilder: (context, index) {
                    final data =
                        obj.containerData[index % obj.containerData.length];
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        data['image'],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Most Selling Products',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'LibreBaskerville',
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 300,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio:
                      1, // Each item will have a square aspect ratio
                ),
                itemCount: obj.mostSelling.length,
                itemBuilder: (context, index) {
                  final data = obj.mostSelling[index];
                  return Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 120, // Adjust as needed based on your design
                          child: Image.asset(
                            data['image'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data['title'],
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '\$${data['price']}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
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
                                const Icon(Icons.star, color: Colors.green),
                                Text(
                                  '${data['rating']}',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_shopping_cart_outlined),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 12),
              child: Text(
                'Category',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'LibreBaskerville',
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              // used for take space by it self and scrollable
              physics: const NeverScrollableScrollPhysics(),
              // used for take space by it self and scrollable
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: obj.category.length,
              itemBuilder: (context, index) {
                final data = obj.category[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: InkWell(
                        onTap: () {
                          if (index == 0) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Item_category(
                                      items: obj.dress,
                                      additionalString:
                                          widget.additionalString)),
                            );
                          } else if (index == 1) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Item_category(
                                      items: obj.dressGirl,
                                      additionalString:
                                          widget.additionalString)),
                            );
                          } else if (index == 2) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Item_category(
                                      items: obj.dressMan,
                                      additionalString:
                                          widget.additionalString)),
                            );
                          } else if (index == 3) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Item_category(
                                      items: obj.dressWoman,
                                      additionalString:
                                          widget.additionalString)),
                            );
                          } else if (index == 4) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Item_category(
                                      items: obj.electronicsList,
                                      additionalString:
                                          widget.additionalString)),
                            );
                          } else if (index == 5) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Item_category(
                                      items: obj.fruits,
                                      additionalString:
                                          widget.additionalString)),
                            );
                          } else if (index == 6) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Item_category(
                                      items: obj.groceries,
                                      additionalString:
                                          widget.additionalString)),
                            );
                          }
                        },
                        child: CircleAvatar(
                          backgroundImage: AssetImage(data['image']),
                          radius: 40,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Center(
                        child: Text(
                          data['title'],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Best Of Electronics',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'LibreBaskerville',
                  fontSize: 20,
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: obj.bestElectronics.length,
                itemBuilder: (context, index) {
                  final data =
                      obj.bestElectronics[index % obj.bestElectronics.length];
                  return Container(
                    width: 150,
                    margin: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 150, // Fixed width
                          height: 150, // Fixed height
                          child: Image.asset(
                            data['image'],
                            fit: BoxFit
                                .cover, // or BoxFit.fill or BoxFit.contain
                          ),
                        ),
                        Text(
                          data['title'],
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Best Of Fitness',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'LibreBaskerville',
                  fontSize: 20,
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: obj.bestFitness.length,
                itemBuilder: (context, index) {
                  final data = obj.bestFitness[index % obj.bestFitness.length];
                  return Container(
                    width: 150,
                    margin: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 150, // Fixed width
                          height: 150, // Fixed height
                          child: Image.asset(
                            data['image'],
                            fit: BoxFit
                                .cover, // or BoxFit.fill or BoxFit.contain
                          ),
                        ),
                        Text(
                          data['title'],
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            const Text(
              'What Our clients Say\'s',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'LibreBaskerville',
                fontSize: 25,
                color: Colors.deepOrange,
                decoration: TextDecoration.underline,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: obj.clients.map((client) {
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
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              decoration: const BoxDecoration(color: Colors.grey),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text('About',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                    'NextGen Online Shop is your ultimate destination for a seamless and enjoyable shopping experience.'),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: const [
                            Text('Contact Us',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('nextgen@gmail.com'),
                            ),
                            Text('+91 6371661504'),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.shopping_cart),
                            )
                          ],
                        ),
                      ),
                      Column(
                        children: const [
                          Text('Social Med..',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: Icon(Icons.facebook),
                          ),
                          Icon(Icons.home),
                          Icon(Icons.adb_sharp),
                        ],
                      ),
                    ],
                  ),
                  const Text(
                    '@nextGen.Copyright.2024',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

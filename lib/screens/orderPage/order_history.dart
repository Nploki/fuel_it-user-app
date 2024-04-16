import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fuel_it/screens/main_screen.dart';
import 'package:fuel_it/screens/orderPage/order_detail.dart';
import 'package:fuel_it/services/user_services.dart';

class completed_orders extends StatefulWidget {
  static const id = "completed_orders";

  const completed_orders({
    Key? key,
  }) : super(key: key);

  @override
  _completed_ordersState createState() => _completed_ordersState();
}

class _completed_ordersState extends State<completed_orders> {
  List<Widget> _buildOrderItems(QuerySnapshot snapshot) {
    List<Widget> items = [];

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;

      items.add(
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: ListTile(
              leading: Image.network(
                data['url'],
                width: 100,
                height: 100,
              ),
              title: Text("Name  :  ${data['PrdName']}"),
              subtitle: Text("Price :  Rs ${data['price']}"),
              trailing: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => order_detail(prd: doc),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.info_rounded,
                    size: 35,
                    color: Colors.purple,
                  )),
            ),
          ),
        ),
      );
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    UserServices services = UserServices();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, MainScreen.id);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                )),
            const Text(
              'Orders history',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('order')
                  .where('userId', isEqualTo: services.userId())
                  // .where('rating', isEqualTo: "")
                  .where('done', isEqualTo: true)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No orders Completed yet.'),
                  );
                }

                return ListView(
                  children: _buildOrderItems(snapshot.data!),
                );
              },
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: 50,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, MainScreen.id);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back_ios),
                    SizedBox(
                      width: 12.5,
                    ),
                    Text(
                      "Back To Home",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}

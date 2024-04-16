import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fuel_it/provider/auth_provider.dart';
import 'package:fuel_it/services/user_services.dart';

class CartPage extends StatefulWidget {
  static const id = "cartPage";

  const CartPage({
    Key? key,
  }) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  AuthProvider _provider = AuthProvider();

  Future<void> _incrementCount(String docId) async {
    final DocumentReference docRef =
        FirebaseFirestore.instance.collection('cart').doc(docId);

    final DocumentSnapshot doc = await docRef.get();

    if (doc.exists) {
      final int count = doc['count'] + 1;
      await docRef.update({'count': count});
    }
  }

  Future<void> _decrementCount(String docId) async {
    final DocumentReference docRef =
        FirebaseFirestore.instance.collection('cart').doc(docId);

    final DocumentSnapshot doc = await docRef.get();

    if (doc.exists) {
      final int count = doc['count'] - 1;
      if (count > 0) {
        await docRef.update({'count': count});
      } else {
        await docRef.delete(); // Remove item from cart if count is zero
      }
    }
  }

  List<Widget> _buildCartItems(QuerySnapshot snapshot) {
    List<Widget> items = [];

    snapshot.docs.forEach((doc) {
      final String docId = doc.id;
      final data = doc.data() as Map<String, dynamic>;
      final int count = data['count'];
      final double price = data['price'];

      items.add(
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue,
                width: .0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ExpansionTile(
              title: Container(
                child: ListTile(
                  leading: Image.network(data['url']),
                  title: Text(data['PrdName']),
                  subtitle: Text('Count: $count, Rate: $price'),
                  trailing: IconButton(
                    icon: const Icon(Icons.shopping_bag),
                    onPressed: () {
                      // Order logic
                    },
                  ),
                ),
              ),
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("Count : "),
                        Container(
                          width: 75,
                          height: 35,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 230, 7, 81),
                                  width: 2),
                              // backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              _decrementCount(docId);
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Color.fromARGB(255, 230, 7, 81),
                            ),
                          ),
                        ),
                        Text(count.toString()),
                        Container(
                          width: 75,
                          height: 35,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(
                                  color: Colors.green.shade600, width: 2),
                            ),
                            onPressed: () {
                              _incrementCount(docId);
                            },
                            child: Icon(Icons.add_shopping_cart_outlined,
                                color: Colors.green.shade600),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: 150,
                            height: 35,
                            color: Colors.pink,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text("Save",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: 150,
                            height: 35,
                            color: Colors.green,
                            child: TextButton(
                              onPressed: () {
                                Map<String, dynamic> productData = {
                                  'url': data['url'],
                                  'productName': data['PrdName'],
                                  'productId': data['prdId'],
                                  'sku': data['sku'],
                                  'shopName': data['shopName'],
                                  'shopId': data['shopId'],
                                  'price': data['price'],
                                  'distance': data['distance'],
                                  'cartId': data['cartId'],
                                };
                                _provider.placeOrder(context, productData);
                              },
                              child: const Text(
                                "Order Now",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });

    return items;
  }

  @override
  Widget build(BuildContext context) {
    UserServices _services = UserServices();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('cart')
            .where('userId', isEqualTo: _services.userId())
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
              child: Text('No items in cart.'),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              return Future.delayed(const Duration(seconds: 5));
            },
            child: ListView(
              children: _buildCartItems(snapshot.data!),
            ),
          );
        },
      ),
    );
  }
}

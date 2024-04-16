import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fuel_it/screens/orderPage/order_history.dart';
import 'package:fuel_it/screens/razor_pay.dart';
import 'package:fuel_it/services/user_services.dart';

class my_orders extends StatefulWidget {
  static const id = "my_orders";

  const my_orders({
    Key? key,
  }) : super(key: key);

  @override
  _my_ordersState createState() => _my_ordersState();
}

void _showRazorPayPage(BuildContext context, String productId, String amount) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return razorPayPage(
        productId: productId,
        amount: amount,
      );
    },
  );
}

class _my_ordersState extends State<my_orders> {
  List<Widget> _buildOrderItems(QuerySnapshot snapshot) {
    List<Widget> items = [];

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      // final bool? orderStatus = data['orderStatus'] == "true" ? true : false;
      final bool? orderStatus = data['orderStatus'] == "true"
          ? true
          : data['orderStatus'] == "false"
              ? false
              : null;

      String orderStatusText = 'Pending';
      if (orderStatus != null) {
        orderStatusText = orderStatus ? 'Accepted' : 'Rejected';
      }

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
              leading: Image.network(data['url']), // Product image
              title: Text(data['PrdName']), // Product name
              subtitle: Row(
                children: [
                  const Text('Order Status:'),
                  Text(
                    data['delivered'] == true ? "Delivered" : orderStatusText,
                    style: TextStyle(
                      color: orderStatusText == "Pending"
                          ? Colors.lightBlueAccent
                          : orderStatusText == 'Accepted'
                              ? Colors.green
                              : Colors.red,
                    ),
                  )
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Text('Shop Name: ${data['shopName']}'),
                          SizedBox(
                            width: 20,
                          ),
                          Visibility(
                            visible: (data['orderStatus'] == '' ||
                                    data['orderStatus'] == "true") &&
                                (data['payment'] == null ||
                                    data['payment'] == false),
                            child: SizedBox(
                              width: 110,
                              height: 35,
                              child: Row(
                                children: [
                                  ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white),
                                      onPressed: () {
                                        _showRazorPayPage(
                                            context,
                                            data['orderId'],
                                            data['price']
                                                .truncate()
                                                .toString());
                                      },
                                      icon: const Icon(
                                        CupertinoIcons.money_rubl_circle_fill,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                      label: Text("PAY")),
                                  // IconButton(
                                  //   onPressed: () {

                                  //     _showRazorPayPage(context, data['orderId'],
                                  //         data['price'].truncate().toString());
                                  //   },
                                  //   icon: const Icon(
                                  //     CupertinoIcons.money_rubl_circle_fill,
                                  //     color: Colors.green,
                                  //     size: 25,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      data['shop_no'].toString().isEmpty
                          ? Text('Shop No: ${data['no']}')
                          : Text('Shop No: ${data['shop_no']}'),
                      Row(
                        children: [
                          const Text('Order Status: '),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 225,
                            height: 40,
                            child: Row(
                              children: [
                                data['delivered']
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: orderStatusText == "Pending"
                                              ? Colors.lightBlueAccent
                                              : orderStatusText == 'Accepted'
                                                  ? Colors.green
                                                  : Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Delivered',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          color: orderStatusText == "Pending"
                                              ? Colors.lightBlueAccent
                                              : orderStatusText == 'Accepted'
                                                  ? Colors.green
                                                  : Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: Row(
                                          children: [
                                            Icon(
                                              orderStatusText == 'Pending'
                                                  ? CupertinoIcons.hourglass
                                                  : orderStatusText ==
                                                          'Accepted'
                                                      ? Icons.check_circle
                                                      : Icons.cancel,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              orderStatusText,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                if (orderStatusText == 'Accepted')
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: IconButton(
                                      icon: const Icon(
                                          CupertinoIcons.info_circle),
                                      color: Colors.red,
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              StatusInfoDialog(
                                            riderName: "riderName",
                                            riderNumber: "riderNumber",
                                            isReady: data['ready'],
                                            isOutForDelivery: data['ofd'],
                                            isDelivered: data['delivered'],
                                            isPaymentReceived: data['payment'],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                if (data['delivered'] == true ||
                                    data['rating'] != null)
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          double rate = 0.0;

                                          return AlertDialog(
                                            title: const Text('Rate the Order'),
                                            content: RatingBar.builder(
                                              initialRating: rate,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 40,
                                              itemPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4.0),
                                              itemBuilder: (context, _) =>
                                                  const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {
                                                rate = rating;
                                              },
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('order')
                                                      .doc(data['orderId'])
                                                      .update({
                                                    'rating': rate,
                                                  });
                                                  updateRating(
                                                      data['shopId'], rate);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Submit'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.rate_review_rounded,
                                      color: Colors.blue,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Orders',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.30,
              height: 35,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, completed_orders.id);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  'History',
                  style: TextStyle(
                      fontSize: 17.5,
                      fontWeight: FontWeight.w300,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('order')
            .where('userId', isEqualTo: services.userId())
            .where('rating', isEqualTo: 0.5)
            .where('done', isEqualTo: false)
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
              child: Text('No orders placed yet.'),
            );
          }

          return ListView(
            children: _buildOrderItems(snapshot.data!),
          );
        },
      ),
    );
  }
}

Future<void> updateRating(String shopId, double newRating) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentSnapshot seller =
      await firestore.collection('seller').doc(shopId).get();

  double currentRating = seller['rating'] + 0 ?? 0.0;
  double updatedRating = (currentRating + newRating) / 2;

  await firestore.collection('seller').doc(shopId).update({
    'rating': updatedRating,
  });
}

class StatusInfoDialog extends StatelessWidget {
  final String riderName;
  final String riderNumber;
  final bool isReady;
  final bool isOutForDelivery;
  final bool isDelivered;
  final bool isPaymentReceived;

  const StatusInfoDialog({
    Key? key,
    required this.riderName,
    required this.riderNumber,
    required this.isReady,
    required this.isOutForDelivery,
    required this.isDelivered,
    required this.isPaymentReceived,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Status Information',
        style: TextStyle(fontSize: 20),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Text('Rider Name: $riderName'),
          // Text('Rider Number: $riderNumber'),
          const SizedBox(height: 20),
          StatusIndicator(
            label: 'Ready',
            isActive: isReady,
          ),
          const SizedBox(height: 10),
          StatusIndicator(
            label: 'Out for Delivery',
            isActive: isOutForDelivery,
          ),
          const SizedBox(height: 10),
          StatusIndicator(
            label: 'Delivered',
            isActive: isDelivered,
          ),
          const SizedBox(height: 10),
          StatusIndicator(
            label: 'Payment Received',
            isActive: isPaymentReceived,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class StatusIndicator extends StatelessWidget {
  final String label;
  final bool isActive;

  const StatusIndicator({
    Key? key,
    required this.label,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label),
        const SizedBox(width: 7),
        Expanded(
          child: LinearProgressIndicator(
            value: isActive ? 1.0 : null,
            backgroundColor: Colors.grey.shade200,
            color: isActive ? Colors.green : Colors.blue,
          ),
        ),
      ],
    );
  }
}

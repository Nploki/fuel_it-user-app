import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class order_detail extends StatefulWidget {
  final QueryDocumentSnapshot prd;
  const order_detail({Key? key, required this.prd}) : super(key: key);

  @override
  State<order_detail> createState() => _order_detailState();
}

class _order_detailState extends State<order_detail> {
  String suub = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Order Details",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                width: 2,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Fuel - IT",
                  style: GoogleFonts.chakraPetch(
                      color: const Color.fromARGB(255, 9, 86, 201),
                      fontSize: 35,
                      fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(
                width: 7.5,
              ),
              Align(
                child: Image.network(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQMXvMgHwpG9wwsrRsflI7JbfJGSPmPErIjNmTOlVSWPpUEtM0v",
                  width: 125,
                  height: 125,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: const Divider(
              color: Colors.grey,
              height: 2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 2.5, top: 10),
            child: Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    const Text(
                      'Order ID',
                      style: TextStyle(fontSize: 17),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    const Text("  :  "),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.prd['orderId'],
                      style: const TextStyle(fontSize: 16.5),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text(
                      'Prd Name',
                      style: TextStyle(fontSize: 17),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    const Text("  :  "),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.prd['PrdName'],
                      style: const TextStyle(fontSize: 16.5),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text(
                      'Count',
                      style: TextStyle(fontSize: 17),
                    ),
                    const SizedBox(
                      width: 60,
                    ),
                    const Text("  :  "),
                    const SizedBox(
                      width: 10,
                    ),
                    if (widget.prd['PrdName'].toString().toLowerCase() ==
                            "petrol" ||
                        widget.prd['PrdName'].toString().toLowerCase() ==
                            "diesel")
                      Text(
                        "${widget.prd['count']}  Liter's",
                        style: const TextStyle(fontSize: 16.5),
                      )
                    else
                      Text(
                        "${widget.prd['count']}  No's",
                        style: const TextStyle(fontSize: 16.5),
                      )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Address',
                      style: TextStyle(fontSize: 17),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    const Text("  : "),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        widget.prd['address'],
                        maxLines: 3,
                        style: const TextStyle(fontSize: 16.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text(
                      'Date & Time',
                      style: TextStyle(fontSize: 17),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text("  : "),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${widget.prd['Time']}",
                      style: const TextStyle(fontSize: 16.5),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text(
                      'Price',
                      style: TextStyle(fontSize: 17),
                    ),
                    const SizedBox(
                      width: 67.5,
                    ),
                    const Text("  : "),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Rs ${widget.prd['price']}",
                      style: const TextStyle(fontSize: 16.5),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text(
                      'Payment ',
                      style: TextStyle(fontSize: 17),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    const Text("  : "),
                    const SizedBox(
                      width: 10,
                    ),
                    if (widget.prd['paymentId'].toString().isNotEmpty)
                      const Text(
                        "Online",
                        style: TextStyle(fontSize: 16.5),
                      )
                    else
                      const Text(
                        "COD",
                        style: TextStyle(fontSize: 16.5),
                      )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                widget.prd['paymentId'].toString().isNotEmpty
                    ? Row(
                        children: [
                          const Text(
                            'Payment Id',
                            style: TextStyle(fontSize: 17),
                          ),
                          const SizedBox(
                            width: 17,
                          ),
                          const Text("  : "),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.prd['paymentId'],
                            style: const TextStyle(fontSize: 16.5),
                          ),
                        ],
                      )
                    : const SizedBox(height: 0),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text(
                      'Rider Name',
                      style: TextStyle(fontSize: 17),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text("  : "),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.prd['r_name'],
                      style: const TextStyle(fontSize: 16.5),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text(
                      'Rider No',
                      style: TextStyle(fontSize: 17),
                    ),
                    const SizedBox(
                      width: 35,
                    ),
                    const Text("  : "),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.prd['r_no'],
                      style: const TextStyle(fontSize: 16.5),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text(
                      'Rating',
                      style: TextStyle(fontSize: 17),
                    ),
                    const SizedBox(
                      width: 55,
                    ),
                    const Text("  : "),
                    const SizedBox(
                      width: 10,
                    ),
                    RatingBarIndicator(
                      rating: (widget.prd['rating'] ?? 0.0),
                      itemBuilder: (_, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 25,
                      direction: Axis.horizontal,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 35,
                ),
                SizedBox(
                  width: 250,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Back To Order\'s',
                      style: TextStyle(fontSize: 20),
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

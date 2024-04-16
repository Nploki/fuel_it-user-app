import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fuel_it/provider/auth_provider.dart';
import 'package:fuel_it/provider/location_provider.dart';
import 'package:fuel_it/services/user_services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  final QueryDocumentSnapshot product;
  final num distance;
  const ProductCard({Key? key, required this.product, required this.distance})
      : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _frontRotation;
  late Animation<double> _backRotation;

  bool _showDetails = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _frontRotation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _backRotation = Tween<double>(begin: -1.0, end: 0.0).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    UserServices _user = UserServices();
    AuthProvider _provider = AuthProvider();
    final locationData = Provider.of<LocationProvider>(context);
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            int tempQuantity = 0;
            return AlertDialog(
              content: Stack(
                children: [
                  widget.product['collection'].toString() == 'Best Selling'
                      ? const Positioned(
                          top: 0,
                          right: 0,
                          child: Icon(
                            Icons.verified_outlined,
                            color: Colors.green,
                            size: 35,
                          ),
                        )
                      : const SizedBox(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 14.5),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage:
                                  NetworkImage(widget.product['url']),
                            ),
                            const SizedBox(
                              width: 12.5,
                            ),
                            Text(
                              '${widget.product['productName']}'.toUpperCase(),
                              style: GoogleFonts.blackOpsOne(
                                  color: Colors.purple, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Text(
                            'About ',
                            style: TextStyle(fontSize: 15),
                          ),
                          const SizedBox(
                            width: 14.5,
                          ),
                          const Text("  :  "),
                          Container(
                            width: 175,
                            child: Text(
                              widget.product['description'].toString(),
                              overflow: TextOverflow.visible,
                              maxLines: 2,
                              style: const TextStyle(fontSize: 14.5),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Price ',
                            style: TextStyle(fontSize: 15),
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          const Text("  :  "),
                          Text(
                            'Rs. ${widget.product['price']} / ${widget.product['quantity']}',
                            style: const TextStyle(fontSize: 14.5),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'SKU ',
                            style: TextStyle(fontSize: 15),
                          ),
                          const SizedBox(
                            width: 45,
                          ),
                          const Text("  :  "),
                          Text(
                            '${widget.product['sku']}',
                            style: const TextStyle(fontSize: 14.5),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Available ',
                            style: TextStyle(fontSize: 15),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text("  :  "),
                          widget.product['stockQty'] >=
                                  widget.product['lowStackQty']
                              ? Text(
                                  '${widget.product['stockQty']}',
                                  style: const TextStyle(
                                    fontSize: 14.5,
                                  ),
                                )
                              : Text(
                                  '${widget.product['stockQty']}',
                                  style: const TextStyle(
                                      fontSize: 14.5, color: Colors.red),
                                ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                FutureBuilder<bool>(
                  future:
                      _provider.isInCart(_user.userId(), widget.product['sku']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final bool isInCart = snapshot.data ?? false;
                      if (isInCart) {
                        return Container(
                          width: 300,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow),
                            onPressed: () {},
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(
                                  CupertinoIcons.bolt_horizontal_circle,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  'Already In Cart',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                // const SizedBox(
                                //   width: 10,
                                // ),
                                IconButton(
                                    onPressed: () {
                                      _provider
                                          .removeFromCart(_user.userId(),
                                              widget.product['sku'])
                                          .then((_) {
                                        Navigator.pop(context);
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text('Removed from cart'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.remove_shopping_cart_rounded,
                                      color: Colors.red,
                                    ))
                              ],
                            ),
                          ),
                        );
                      } else {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow),
                          onPressed: () {
                            _provider
                                .addToCart(
                              widget.product['productName'],
                              widget.product['sku'],
                              1,
                              widget.product['price'],
                              widget.product['prdId'],
                              widget.product['url'],
                              widget.product['shopName'],
                              widget.product['sellerUid'],
                              widget.distance,
                            )
                                .then((_) {
                              Navigator.pop(context);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('Added to Cart'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            // Navigator.pop(context);
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.cart,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Add to Cart',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.maxFinite / 2,
                  height: 50,
                  child: TextButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () async {
                      Position position =
                          await locationData.getCurrentPosition();
                      print(position.latitude);
                      print(position.longitude);
                      Map<String, dynamic> productData = {
                        'url': widget.product['url'],
                        'productName': widget.product['productName'],
                        'productId': widget.product['prdId'],
                        'sku': widget.product['sku'],
                        'shopName': widget.product['shopName'],
                        'shopId': widget.product['sellerUid'],
                        'price': widget.product['price'],
                        'distance': widget.distance.round(),
                        'latitude': position.latitude,
                        'longitude': position.longitude,
                      };
                      Navigator.pop(context);
                      _provider.placeOrder(context, productData);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Place Order',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_showDetails
                  ? _backRotation.value * 3.141792
                  : _frontRotation.value * 3.141792),
            alignment: Alignment.center,
            child: Card(
              color: _showDetails ? Colors.amber : Colors.white,
              child: _showDetails ? _buildBackWidget() : _buildFrontWidget(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFrontWidget() {
    return ListTile(
      subtitle: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.product['productName'].toString().toUpperCase(),
              style: GoogleFonts.balooBhaina2(
                fontSize: 14.5,
              ),
            ),
          ],
        ),
      ),
      title: Stack(
        children: [
          Image.network(
            widget.product['url'],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () {
                if (!_showDetails) {
                  setState(() {
                    _showDetails = true;
                    _controller.forward();
                  });
                }
              },
              icon: const Icon(
                Icons.info_outline_rounded,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackWidget() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showDetails = false;
          _controller.reverse();
        });
      },
      child: ListTile(
        title: Text(
          widget.product['productName'].toString().toUpperCase(),
          style: GoogleFonts.yatraOne(color: Colors.white, fontSize: 17),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('ID'),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(" : "),
                  Text('${widget.product['sku']}'),
                ],
              ),
              Row(
                children: [
                  const Text('Stock'),
                  const SizedBox(
                    width: 3,
                  ),
                  const Text(" : "),
                  Text('${widget.product['stockQty']}'),
                ],
              ),
              Row(
                children: [
                  const Text('Price'),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(" : "),
                  Text('${widget.product['price']}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

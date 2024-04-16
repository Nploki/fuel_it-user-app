import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';

class vendor_slider extends StatefulWidget {
  final String vendorId;

  const vendor_slider({Key? key, required this.vendorId}) : super(key: key);

  @override
  State<vendor_slider> createState() => _vendor_sliderState();
}

class _vendor_sliderState extends State<vendor_slider> {
  late Future<List<String>> _sliderImagesFuture;

  int _index = 0;
  int _dataLength = 1;

  @override
  void initState() {
    super.initState();
    _sliderImagesFuture = getSliderImageFromDB(widget.vendorId);
  }

  Future<List<String>> getSliderImageFromDB(String vendorId) async {
    var _firestore = FirebaseFirestore.instance;
    DocumentSnapshot vendorSnapshot =
        await _firestore.collection('vendor_slider').doc(vendorId).get();
    if (!vendorSnapshot.exists) {
      return [];
    }
    Map<String, dynamic> vendorData =
        vendorSnapshot.data() as Map<String, dynamic>;
    List<String> images = [];
    if (vendorData.containsKey('image')) {
      images = List<String>.from(vendorData['image']);
    }
    // if (images.isEmpty) {
    //   images = [
    //     'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQWQRRWcy_vTe-PYdSxY4yY_yh-OjpEfBhUSQ&usqp=CAU'
    //   ]; // Add a default image URL
    // }
    if (mounted) {
      setState(() {
        _dataLength = images.length;
      });
    }
    return images;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.22,
      child: Column(
        children: [
          FutureBuilder(
            future: _sliderImagesFuture,
            builder: (context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: CarouselSlider.builder(
                    itemCount:
                        snapshot.data != null && snapshot.data!.isNotEmpty
                            ? snapshot.data!.length
                            : 1,
                    itemBuilder: (context, index, realIndex) {
                      if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                        String imageUrl = snapshot.data![index];
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.fill,
                          ),
                        );
                      } else {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Image.network(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRCQoQ7p-zw4bR4mOzZK3RV9CAOMx2uXF0K1w&usqp=CAU',
                            fit: BoxFit.fill,
                          ),
                        );
                      }
                    },
                    options: CarouselOptions(
                      viewportFraction: 1,
                      initialPage: 0,
                      autoPlay: true,
                      height: 150,
                      onPageChanged: (int i, carouselPageChangedReason) {
                        setState(() {
                          _index = i;
                        });
                      },
                    ),
                  ),
                );
              }
            },
          ),
          DotsIndicator(
            dotsCount: _dataLength,
            position: _index,
            decorator: DotsDecorator(
              size: const Size.square(5.0),
              activeSize: const Size(18.0, 5.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
            ),
          ),
        ],
      ),
    );
  }
}

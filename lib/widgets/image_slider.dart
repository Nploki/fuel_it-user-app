import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({Key? key}) : super(key: key);

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  late Future<QuerySnapshot> _sliderImagesFuture;

  int _index = 0;
  int _dataLength = 1;

  @override
  void initState() {
    super.initState();
    _sliderImagesFuture = getSliderImageFromDB();
  }

  Future<QuerySnapshot> getSliderImageFromDB() async {
    var _firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await _firestore.collection('slider').get();
    if (mounted) {
      setState(() {
        _dataLength = snapshot.docs.length;
      });
    }
    return snapshot;
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
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Show loading indicator while fetching data
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: CarouselSlider.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index, realIndex) {
                      DocumentSnapshot sliderImage = snapshot.data!.docs[index];
                      Map<String, dynamic> getImage =
                          sliderImage.data() as Map<String, dynamic>;
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(
                          getImage['image'],
                          fit: BoxFit.fill,
                        ),
                      );
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
                        }),
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

import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:fuel_it/constants.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

final _controller = PageController(
  initialPage: 0,
);

int _currentpage = 0;

final List<Widget> _pages = [
  Column(
    children: [
      Expanded(
        child: Image.network(
            "https://img.freepik.com/free-vector/order-confirmed-concept-illustration_114360-1545.jpg"),
      ),
      const Text("Order your Required Fuel ...", style: onboardheadertextstyle),
    ],
  ),
  Column(
    children: [
      Expanded(
        child: Image.network(
            "https://images.template.net/84891/free-location-illustration-wtiua.jpg"),
      ),
      const Text("Set Your Delivery Location ...",
          style: onboardheadertextstyle)
    ],
  ),
  Column(
    children: [
      Expanded(
        child: Image.network(
            "https://img.freepik.com/premium-vector/online-delivery-service-concept-vector-illustration-with-delivery-courier-character_675567-2568.jpg"),
      ),
      const Text("Quick Delivery at Your Door Step ...",
          style: onboardheadertextstyle)
    ],
  )
];

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double w = size.width;
    double h = size.height;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              children: _pages,
              onPageChanged: (index) {
                setState(() {
                  _currentpage = index;
                });
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          DotsIndicator(
            dotsCount: _pages.length,
            position: _currentpage,
            decorator: DotsDecorator(
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
            ),
          ),
        ],
      ),
    );
  }
}

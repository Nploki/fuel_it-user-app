import 'package:flutter/material.dart';
import 'package:fuel_it/widgets/image_slider.dart';
import 'package:fuel_it/widgets/my_app_bar.dart';
import 'package:fuel_it/widgets/near_by_store.dart';

class HomeScreen extends StatefulWidget {
  static const id = 'home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Scaffold(
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(125), child: MyAppBar()),
            body: ListView(
              children: [
                const ImageSlider(),
                Container(
                  height: 500,
                  child: const NearByStore(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fuel_it/provider/location_provider.dart';
import 'package:fuel_it/provider/auth_provider.dart' as Auth;
import 'package:fuel_it/screens/location_bunk.dart';
import 'package:fuel_it/screens/map_screen.dart';
import 'package:fuel_it/screens/welcome_screen.dart';
import 'package:fuel_it/widgets/image_slider.dart';
import 'package:fuel_it/widgets/my_app_bar.dart';
import 'package:fuel_it/widgets/top_pick_store.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static const id = 'home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth.AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);
    return Scaffold(
      appBar:
          PreferredSize(preferredSize: Size.fromHeight(112), child: MyAppBar()),
      body: Center(
        child: Column(
          children: [
            ImageSlider(),
            Container(
              height: 210,
              child: TopPickStore(),
              // color: Colors.lightBlue,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, locate_bunk.id);
              },
              child: Text('Locate On Map'),
            )
          ],
        ),
      ),
    );
  }
}

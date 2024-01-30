import 'package:flutter/material.dart';
import 'package:fuel_it/provider/location_provider.dart';
import 'package:fuel_it/provider/auth_provider.dart' as AuthService;

import 'package:fuel_it/screens/map_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fuel_it/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatefulWidget {
  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  String _location = '';

  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? location = prefs.getString('address');
    setState(() {
      _location = location ?? 'Unknown';
    });
  }

  // Inside your _HomeScreenState class
  Widget _buildAppBarTitle() {
    final locationData = Provider.of<LocationProvider>(context);

    final auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    return TextButton(
      onPressed: () {},
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: Text(
                  _location,
                  style: TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              IconButton(
                onPressed: () {
                  if (user != null) {
                    Navigator.pushReplacementNamed(
                      context,
                      MapScreen.id,
                      arguments: {
                        'id': user.uid,
                        'number': user.phoneNumber,
                      },
                    );
                  }
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthService.AuthProvider>(context);
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0.0,
      leading: Container(),
      title: _buildAppBarTitle(), // Use a method to create the title widget
      actions: [
        IconButton(
          onPressed: () {
            FirebaseAuth.instance.signOut().then(
              (value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => welcome_screen(),
                  ),
                );
              },
            );
          },
          icon: const Icon(
            Icons.power_settings_new,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.account_circle_outlined,
            color: Colors.white,
          ),
        ),
      ],
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.zero,
              fillColor: Colors.white,
              filled: true,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.amber,
    );
  }
}

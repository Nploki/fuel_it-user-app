import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fuel_it/screens/map_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fuel_it/screens/welcome_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0.0,
      centerTitle: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 10, 10),
            child: Text(
              "Fuel - It",
              style: GoogleFonts.chakraPetch(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 10, 10),
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.black,
              child: CircleAvatar(
                radius: 21,
                backgroundColor: Colors.white,
                child: IconButton(
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
                      Icons.power_settings_new_rounded,
                      size: 25,
                      color: Colors.red,
                    )),
              ),
            ),
          )
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 25,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: _location,
                    prefixIcon: const Icon(
                      Icons.home_outlined,
                      size: 32.5,
                      color: Colors.blue,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.zero,
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (user != null) {
                          Navigator.pushReplacementNamed(context, MapScreen.id,
                              arguments: {
                                'id': user.uid,
                                'number': user.phoneNumber,
                              });
                        }
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.green,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.amber,
    );
  }
}

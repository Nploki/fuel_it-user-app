import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fuel_it/screens/HomeScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fuel_it/screens/cart_screen.dart';
import 'package:fuel_it/screens/location_bunk.dart';
import 'package:fuel_it/screens/orderPage/my_orders.dart';
import 'package:fuel_it/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  static const id = "main_screen";

  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    locate_bunk(),
    const CartPage(),
    const my_orders(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isTruee = false;
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.greenAccent,
        selectedIconTheme: const IconThemeData(color: Colors.amber),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.blue,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on_outlined, color: Colors.blue),
              label: 'Locate Bunk'),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.shopping_cart, color: Colors.blue),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag, color: Colors.blue),
            label: 'My Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.blue),
            label: 'Profile',
          ),
        ],
        backgroundColor: Colors.blue,
        selectedLabelStyle: GoogleFonts.chakraPetch(
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(color: Colors.amber),
      ),
    );
  }
}

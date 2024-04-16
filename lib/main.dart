import 'package:flutter/material.dart';
import 'package:fuel_it/firebase_options.dart';
import 'package:fuel_it/provider/location_provider.dart';
import 'package:fuel_it/screens/HomeScreen.dart';
import 'package:fuel_it/screens/cart_screen.dart';
import 'package:fuel_it/screens/location_bunk.dart';
import 'package:fuel_it/screens/main_screen.dart';
import 'package:fuel_it/screens/map_screen.dart';
import 'package:fuel_it/screens/orderPage/my_orders.dart';
import 'package:fuel_it/screens/orderPage/order_history.dart';
import 'package:fuel_it/screens/vendor_home_screen.dart';
import 'package:provider/provider.dart';
import 'package:fuel_it/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fuel_it/provider/store_provider.dart';
import 'package:fuel_it/provider/auth_provider.dart' as MyAppAuthProvider;

import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => storeProvider()),
        ChangeNotifierProvider(create: (_) => MyAppAuthProvider.AuthProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.amber,
          fontFamily: 'eno',
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id: (context) => SplashScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          welcome_screen.id: (context) => welcome_screen(),
          MapScreen.id: (context) => MapScreen(),
          locate_bunk.id: (context) => locate_bunk(),
          completed_orders.id: (context) => completed_orders(),
          my_orders.id: (context) => my_orders(),
          MainScreen.id: (context) => MainScreen(),
          CartPage.id: (context) => CartPage(),
          vendorHomeScreen.id: (context) => vendorHomeScreen()
        });
  }
}

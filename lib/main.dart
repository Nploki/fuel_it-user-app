import 'package:flutter/material.dart';
import 'package:fuel_it/firebase_options.dart';
import 'package:fuel_it/screens/HomeScreen.dart';
import 'package:fuel_it/screens/map_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fuel_it/screens/onboarding_screen.dart';
import 'package:fuel_it/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
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
        ChangeNotifierProvider(create: (_) => MyAppAuthProvider.AuthProvider())
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
          primaryColor: Colors.teal.shade900,
        ),
        initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id: (context) => SplashScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          welcome_screen.id: (context) => welcome_screen(),
          // MapScreen.id : (context)=>MapScreen(),
        });
  }
}

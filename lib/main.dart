import 'package:bmm_shop_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/signup_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BM App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/home',
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => RegisterScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/home':(context)=>const HomeScreen(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => LoginScreen()); // Fallback route
      },
    );
  }
}

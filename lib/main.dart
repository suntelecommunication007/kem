import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kem/screen/auth_gate.dart';

import '../screen/home_screen.dart';

import 'firebase_options.dart';
import 'screen/cart_screen.dart';
import 'screen/profile_screen.dart';
import 'screen/search_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const AuthGate());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  final _items = const <Widget>[
    Icon(Icons.home),
    Icon(Icons.search),
    Icon(Icons.shopping_bag),
    Icon(Icons.person)
  ];
  final _screen = const [
    HomeScreen(),
    SearchScreen(),
    CartScreen(),
    MyProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screen[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.black,
        items: _items,
        index: _selectedIndex,
        onTap: (count) => setState(() {
          _selectedIndex = count;
        }),
      ),
    );
  }
}




/*



*/
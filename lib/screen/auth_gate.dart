import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutterfire_ui/auth.dart';
import 'package:kem/main.dart';
import 'package:kem/screen/Product_detail_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              return const MyApp();
            }
            return PhoneInputScreen(
              headerBuilder: (context, constraints, shrinkOffset) {
                return Padding(
                  padding: const EdgeInsets.all(20).copyWith(top: 40),
                  child: Icon(
                    Icons.phone,
                    color: Colors.blue,
                    size: constraints.maxWidth / 4 * (1 - shrinkOffset),
                  ),
                );
              },
              sideBuilder: (context, constraints) {
                return Padding(
                  padding: const EdgeInsets.all(20).copyWith(top: 40),
                  child: Icon(
                    Icons.phone,
                    color: Colors.blue,
                    size: constraints.maxWidth / 4,
                  ),
                );
              },
            );
          },
        ),
      ),
      routes: {
        ProductDetailScreen.routeName: (context) => const ProductDetailScreen()
      },
    );
  }
}

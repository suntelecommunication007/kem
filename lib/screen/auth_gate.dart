import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutterfire_ui/auth.dart';
import 'package:kem/bloc/cart/cart_bloc.dart';
import 'package:kem/main.dart';
import 'package:kem/screen/Product_detail_screen.dart';

import '../bloc/category/category_bloc.dart';
import '../bloc/products/products_bloc.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductsBloc(),
        ),
        BlocProvider(
          create: (context) => CategoryBloc(),
        ),
        BlocProvider(
          create: (context) => CartBloc(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(useMaterial3: true),
        debugShowCheckedModeBanner: false,
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
          ProductDetailScreen.routeName: (context) =>
              const ProductDetailScreen()
        },
      ),
    );
  }
}

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cart/cart_bloc.dart';

class CartIcon extends StatelessWidget {
  const CartIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoaded) {
          return Badge(
            badgeContent: Text('${state.cart.cartList.length}'),
            child: const Icon(Icons.shopping_cart),
          );
        }
        return Badge(
          child: const Icon(Icons.shopping_cart),
        );
      },
    );
  }
}

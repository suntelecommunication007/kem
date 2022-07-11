// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:kem/model/cart_item.dart';

class Cart {
  List<CartItem> cartList;
  Cart({
    required this.cartList,
  });

  Cart copyWith({
    List<CartItem>? cartList,
  }) {
    return Cart(
      cartList: cartList ?? this.cartList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cartList': cartList.map((x) => x.toMap()).toList(),
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      cartList: List<CartItem>.from(
        (map['cartList'] as List<int>).map<CartItem>(
          (x) => CartItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) =>
      Cart.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Cart(cartList: $cartList)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Cart && listEquals(other.cartList, cartList);
  }

  @override
  int get hashCode => cartList.hashCode;
}

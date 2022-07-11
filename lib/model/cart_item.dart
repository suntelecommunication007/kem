// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CartItem {
  String productId;
  int count;
  String priceConfigKey;
  CartItem({
    required this.productId,
    required this.count,
    required this.priceConfigKey,
  });

  CartItem copyWith({
    String? productId,
    int? count,
    String? priceConfigKey,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      count: count ?? this.count,
      priceConfigKey: priceConfigKey ?? this.priceConfigKey,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productId': productId,
      'count': count,
      'priceConfigKey': priceConfigKey,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: map['productId'] as String,
      count: map['count'] as int,
      priceConfigKey: map['priceConfigKey'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItem.fromJson(String source) =>
      CartItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CartItem(productId: $productId, count: $count, priceConfigKey: $priceConfigKey)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartItem &&
        other.productId == productId &&
        other.count == count &&
        other.priceConfigKey == priceConfigKey;
  }

  @override
  int get hashCode =>
      productId.hashCode ^ count.hashCode ^ priceConfigKey.hashCode;
}

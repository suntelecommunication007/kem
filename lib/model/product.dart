// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Product {
  final String id;
  final String name;
  final String barcode;
  final String category;
  final String imageUrl;
  final String description;
  final Map<String, double> priceConfig;
  Product({
    required this.id,
    required this.name,
    required this.barcode,
    required this.category,
    required this.imageUrl,
    required this.description,
    required this.priceConfig,
  });

  Product copyWith({
    String? id,
    String? name,
    String? barcode,
    String? category,
    String? imageUrl,
    String? description,
    Map<String, double>? priceConfig,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      priceConfig: priceConfig ?? this.priceConfig,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'barcode': barcode,
      'category': category,
      'imageUrl': imageUrl,
      'description': description,
      'priceConfig': priceConfig,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
        id: map['id'] as String,
        name: map['name'] as String,
        barcode: map['barcode'] as String,
        category: map['category'] as String,
        imageUrl: map['imageUrl'] as String,
        description: map['description'] as String,
        priceConfig: Map<String, double>.from(
          (map['priceConfig'] as Map<String, double>),
        ));
  }

  factory Product.fromFireBase(
      String firebaseDocumentId, Map<String, dynamic> map) {
    return Product(
      id: firebaseDocumentId,
      name: map['name'] as String,
      barcode: map['barcode'] as String,
      category: map['category'] as String,
      imageUrl: map['imageUrl'] as String,
      description: map['description'] as String,
      priceConfig: Map<String, double>.from(
        (map['priceConfig']),
      ),
    );
  }
  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Product(id: $id, name: $name, barcode: $barcode, category: $category, imageUrl: $imageUrl, description: $description, priceConfig: $priceConfig)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.id == id &&
        other.name == name &&
        other.barcode == barcode &&
        other.category == category &&
        other.imageUrl == imageUrl &&
        other.description == description &&
        mapEquals(other.priceConfig, priceConfig);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        barcode.hashCode ^
        category.hashCode ^
        imageUrl.hashCode ^
        description.hashCode ^
        priceConfig.hashCode;
  }
}

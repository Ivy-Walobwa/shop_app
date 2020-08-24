import 'package:flutter/foundation.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product({
    @required this.price,
    @required this.id,
    @required this.title,
    @required this.imageUrl,
    @required this.description,
    this.isFavorite = false,
  });
}

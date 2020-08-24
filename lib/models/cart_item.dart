import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final double price;
  final String title;
  final int quantity;

  CartItem({
    @required this.price,
    @required this.title,
    @required this.id,
    @required this.quantity,});
}
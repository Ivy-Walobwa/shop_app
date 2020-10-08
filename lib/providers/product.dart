import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
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

  Future<void> toggleIsFavoriteState(String token) async {
    final url =
        'https://flutter-shop-app-4d183.firebaseio.com/products/$id.json?auth=$token';
    final oldStatus = isFavorite;

    isFavorite = !isFavorite;
    notifyListeners();

    try {
      final response = await http.patch(url,
        body: json.encode({
          'isFavorite': isFavorite,
        }));
      if (response.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
      }
    } catch (err) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}

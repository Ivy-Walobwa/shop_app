
import 'package:flutter/material.dart';

import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemsInCart {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addItems(String productId, double price, String title) {

    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (value) => CartItem(
            price: value.price,
            title: value.title,
            id: value.id,
            quantity: value.quantity + 1),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
            price: price,
            title: title,
            id: DateTime.now().toString(),
            quantity: 1),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (value) =>
            CartItem(price: value.price, title: value.title, id: value.id, quantity: value.quantity - 1),
      );
    }else{
      _items.remove(productId);
    }
    notifyListeners();
  }
}

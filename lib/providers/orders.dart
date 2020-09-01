import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/cart_item.dart';
import '../models/order_item.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url = 'https://flutter-shop-app-4d183.firebaseio.com/orders.json';
    final timestamp = DateTime.now();

    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'price': cp.price,
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                })
            .toList(),
      }),
    );

    _orders.insert(
      0,
      OrderItem(
        dateTime: timestamp,
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }

  Future<void> fetchOrdersFromDB() async {
    const url = 'https://flutter-shop-app-4d183.firebaseio.com/orders.json';
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if(extractedData == null){
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          dateTime: DateTime.parse(orderData['dateTime']),
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  price: item['price'],
                  title: item['title'],
                  id: item['id'],
                  quantity: item['quantity'],
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}

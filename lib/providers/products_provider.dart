import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'product.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  final String token;
  final String userId;

  List<Product> items = [
//    Product(
//      id: 'p4',
//      title: 'A Pan',
//      description: 'Prepare any meal you want.',
//      price: 49.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//    ),
  ];

  ProductsProvider(this.token,this.userId, this.items);


  List<Product> get itemsList {
    return [...items];
  }

  List<Product> get favoriteItems {
    return items.where((item) => item.isFavorite == true).toList();
  }

  Product findById(String id) {
    return items.firstWhere((prod) => prod.id == id);
  }

  Future<void> getProductsFromDB([bool filter = false]) async {
    final filterString = filter ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = 'https://flutter-shop-app-4d183.firebaseio.com/products.json?auth=$token&$filterString';

    try {
      final response = await http.get(url);
      final loadedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> fetchedProducts = [];
      if (loadedData == null) {
        return;
      }
      url = 'https://flutter-shop-app-4d183.firebaseio.com/userFavorites/$userId.json?auth=$token';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);

      loadedData.forEach((prodId, prodData) {
        fetchedProducts.add(Product(
          price: prodData['price'],
          id: prodId,
          title: prodData['title'],
          imageUrl: prodData['imageUrl'],
          description: prodData['description'],
          isFavorite: favoriteData== null ? false : favoriteData[prodId] ?? false,
        ));
      });
      items = fetchedProducts;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> addProducts(Product product) async {
    var url = 'https://flutter-shop-app-4d183.firebaseio.com/products.json?auth=$token';

    try {
      var response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId,
          }));
      final _newProduct = Product(
          price: product.price,
          id: json.decode(response.body)['name'],
          title: product.title,
          imageUrl: product.imageUrl,
          description: product.imageUrl,
      );

      items.add(_newProduct);

      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final url =
        'https://flutter-shop-app-4d183.firebaseio.com/products/$id.json?auth=$token';

    final prodIndex = items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String productId) async {
    final url =
        'https://flutter-shop-app-4d183.firebaseio.com/products/$productId.json?auth=$token';

    final prodIndex = items.indexWhere((element) => element.id == productId);
    var existingProd = items[prodIndex];

    items.removeAt(prodIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      items.insert(prodIndex, existingProd);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProd = null;
  }
}

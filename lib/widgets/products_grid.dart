import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import 'product_item.dart';

class ProductsGrid extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final loadedProducts = productsData.items;
    return GridView.builder(
      padding: EdgeInsets.all(20.0),
      itemCount: loadedProducts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2/2.5
      ),
      itemBuilder: (ctx, index) => ProductItem(
        title: loadedProducts[index].title,
        id: loadedProducts[index].id,
        imageUrl: loadedProducts[index].imageUrl,
        price: loadedProducts[index].price,
      ),
    );
  }
}
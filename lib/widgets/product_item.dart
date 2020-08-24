import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../screens/product_detail_screen.dart';
import '../providers/cart_provider.dart';


class ProductItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<CartProvider>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: (){
            Navigator.pushNamed(context, ProductDetailScreen.routeName, arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        header: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(),
            Consumer<Product>(
              builder: (ctx, product, child) => IconButton(
                icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  product.toggleIsFavoriteState();
                },
              ),
            ),
          ],
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(product.title),
          subtitle: Text('\$${product.price}'),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItems(product.id, product.price, product.title);
            },
          ),
        ),
      ),
    );
  }
}

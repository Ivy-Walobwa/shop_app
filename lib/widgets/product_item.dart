import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String title;
  final double price;

  ProductItem({
    this.imageUrl,
    this.title,
    this.id,
    this.price,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: (){
            Navigator.pushNamed(context, ProductDetailScreen.routeName, arguments: id);
          },
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        header: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(),
            IconButton(
              icon: Icon(Icons.favorite_border),
              onPressed: () {},
            ),
          ],
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(title),
          subtitle: Text('\$$price'),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/order_item_widget.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Orders',
        ),
      ),
      body: FutureBuilder(future: Provider.of<Orders>(context, listen: false).fetchOrdersFromDB(), builder: (ctx, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
         return Center(child: CircularProgressIndicator());
        }else{
          if(snapshot.error != null){
            return Center(child: Text('An error occurred'),);
          }else{
            return Consumer<Orders>(builder: (ctx, orderData, child)=>
              ListView.builder(
                itemBuilder: (ctx, i) =>
                    OrderItemWidget(
                      order: orderData.orders[i],
                    ),
                itemCount: orderData.orders.length,
              )
            ,);
          }
        }
      },)
    );
  }

}

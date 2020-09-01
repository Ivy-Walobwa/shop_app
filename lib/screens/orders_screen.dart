import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/order_item_widget.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

  var _isLoading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async{
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Orders>(context, listen: false).fetchOrdersFromDB();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Orders',
        ),
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator()): ListView.builder(
        itemBuilder: (ctx, i) =>
            OrderItemWidget(
              order: orderData.orders[i],
            ),
        itemCount: orderData.orders.length,
      ),
    );
  }

}

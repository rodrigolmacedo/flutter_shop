import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_widget.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Orders orders = Provider.of<Orders>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      body: ListView.builder(
          itemCount: orders.itemsCount,
          itemBuilder: (context, index) => OrderWidget(
                order: orders.items[index],
              )),
    );
  }
}

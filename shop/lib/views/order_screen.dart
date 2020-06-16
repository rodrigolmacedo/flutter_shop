import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_widget.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).loadOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.error != null) {
            return Center(
              child: Text('Ocorreu um erro inesperado.'),
            );
          } else {
            return Consumer<Orders>(
              builder: (context, orders, _) => RefreshIndicator(
                onRefresh:
                    Provider.of<Orders>(context, listen: false).loadOrders,
                child: ListView.builder(
                    itemCount: orders.itemsCount,
                    itemBuilder: (context, index) => OrderWidget(
                          order: orders.items[index],
                        )),
              ),
            );
          }
        },
      ),
      // body: _isLoading
      //     ? Center(
      //         child: CircularProgressIndicator(),
      //       )
      //     : RefreshIndicator(
      //         onRefresh: _loadItems,
      //         child: ListView.builder(
      //             itemCount: orders.itemsCount,
      //             itemBuilder: (context, index) => OrderWidget(
      //                   order: orders.items[index],
      //                 )),
      //       ),
    );
  }
}

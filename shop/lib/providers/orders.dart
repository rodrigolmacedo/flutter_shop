import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop/providers/cart.dart';
import 'package:shop/utils/constants.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  Order({this.id, this.total, this.products, this.date});
}

class Orders with ChangeNotifier {
  final String _baseUrl = '${Constants.BASE_API_URL}/orders';

  List<Order> _items = [];

  List<Order> get items {
    return [..._items].reversed.toList();
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    final response = await http.get("$_baseUrl.json");
    Map<String, dynamic> data = json.decode(response.body);
    _items.clear();
    if (data != null) {
      data.forEach((orderId, orderData) {
        _items.add(Order(
          id: orderId,
          total: orderData['total'],
          date: DateTime.parse(orderData['date']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                    id: item['id'],
                    productId: item['productId'],
                    tittle: item['tittle'],
                    quantity: item['quantity'],
                    price: item['price']),
              )
              .toList(),
        ));
      });
      notifyListeners();
    }
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    final response = await http.post(
      "$_baseUrl.json",
      body: json.encode({
        "total": cart.totalAmount,
        "date": date.toIso8601String(),
        "products": cart.items.values
            .map((cartItem) => {
                  "id": cartItem.id,
                  "productId": cartItem.productId,
                  "tittle": cartItem.tittle,
                  "quantity": cartItem.quantity,
                  "price": cartItem.price,
                })
            .toList()
      }),
    );

    _items.insert(
        0,
        Order(
            id: json.decode(response.body)['name'],
            total: cart.totalAmount,
            date: date,
            products: cart.items.values.toList()));

    notifyListeners();
  }
}

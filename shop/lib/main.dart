import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/utils/custom_route.dart';
import 'package:shop/views/auth_home_screen.dart';
import 'package:shop/views/cart_screen.dart';
import 'package:shop/views/order_screen.dart';
import 'package:shop/views/product_detail_screen.dart';
import 'package:shop/views/products_screen.dart';
import 'package:shop/views/proudct_form_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => new Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => new Products(),
          update: (ctx, auth, previousProducts) =>
              new Products(auth.token, auth.userId, previousProducts.items),
        ),
        ChangeNotifierProvider(create: (_) => new Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => new Orders(),
          update: (ctx, auth, previousOrders) =>
              new Orders(auth.token, auth.userId, previousOrders.items),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Minha Loja',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionsBuilder(),
              TargetPlatform.iOS: CustomPageTransitionsBuilder(),
            })),
        routes: {
          AppRoutes.PRODUCT_DETAIL: (context) => ProductDetailScreen(),
          AppRoutes.PRODUCT_FORM: (context) => ProductFormScreen(),
          AppRoutes.PRODUCTS: (context) => ProductsScreen(),
          AppRoutes.CART: (context) => CartScreen(),
          AppRoutes.AUTH_HOME: (context) => AuthOrHomeScreen(),
          AppRoutes.ORDERS: (context) => OrderScreen(),
        },
      ),
    );
  }
}

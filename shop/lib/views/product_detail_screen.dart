import 'package:flutter/material.dart';
import 'package:shop/providers/product.dart';

class ProductDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context).settings.arguments as Product;

    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
              title: Text(
                product.title,
                softWrap: true,
                textAlign: TextAlign.justify,
              ),
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Hero(
                    tag: product.id,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(0, 0, 0, 0.6),
                        Color.fromRGBO(0, 0, 0, 0)
                      ],
                      begin: Alignment(0, 0.8),
                      end: Alignment(0, 0),
                    )),
                  ),
                ],
              )),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          SizedBox(
            height: 10,
          ),
          Text(
            'R\$ ${product.price}',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: Text(
              product.description,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 1000,
          )
        ]))
      ],
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                onPressed: () => Navigator.of(context)
                    .pushNamed(AppRoutes.PRODUCT_FORM, arguments: product)),
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Deseja realmente excluir o produto?'),
                      content: Text(product.title),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text('Sim')),
                        FlatButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('Não')),
                      ],
                    ),
                  ).then((value) async {
                    if (value) {
                      try {
                        await Provider.of<Products>(context, listen: false)
                            .deleteProduct(product.id);
                      } catch (error) {
                        scaffold.showSnackBar(
                            SnackBar(content: Text(error.toString())));
                      }
                    }
                  });
                })
          ],
        ),
      ),
    );
  }
}

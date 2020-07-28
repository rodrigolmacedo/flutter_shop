import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageURL = FocusNode();
  final _imageUrlController = TextEditingController();

  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool _isLoading = false;

  void _updateImageUrl() {
    if (isValidImageUrl(_imageUrlController.text)) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _imageURL.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final product = ModalRoute.of(context).settings.arguments as Product;
      if (product != null) {
        _formData['id'] = product.id;
        _formData['description'] = product.description;
        _formData['price'] = product.price;
        _formData['tittle'] = product.title;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = _formData['imageUrl'];
      } else {
        _formData['price'] = '';
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageURL.removeListener(_updateImageUrl);
    _imageURL.dispose();
  }

  bool isValidImageUrl(String url) {
    bool startWithHttp = url.toLowerCase().startsWith('http://');
    bool startWithHttps = url.toLowerCase().startsWith('https://');
    bool endsWithPng = url.toLowerCase().endsWith('.png');
    bool endsWithJpg = url.toLowerCase().endsWith('.jpg');
    bool endsWithJpeg = url.toLowerCase().endsWith('.jpeg');
    return ((startWithHttp || startWithHttps) &&
        (endsWithJpeg || endsWithJpg || endsWithPng));
  }

  Future<void> _saveForm() async {
    bool isValid = _form.currentState.validate();

    if (!isValid) return;

    _form.currentState.save();
    final product = Product(
        id: _formData['id'],
        title: _formData['tittle'],
        description: _formData['description'],
        price: _formData['price'],
        imageUrl: _formData['imageUrl']);

    setState(() {
      _isLoading = true;
    });

    final products = Provider.of<Products>(context, listen: false);

    try {
      if (_formData['id'] == null) {
        await products.addProduct(product);
      } else {
        await products.updateProduct(product);
      }
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Ocorreu um erro!'),
          content: Text(
            'Ocorreu um erro para salvar o produto!',
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.of(context).pop(), child: Text('Ok'))
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário Produto'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm)
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _formData['tittle'],
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(labelText: 'Título'),
                        onSaved: (newValue) => _formData['tittle'] = newValue,
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_priceFocusNode),
                        validator: (value) {
                          if (value.trim().isEmpty)
                            return 'Informe um título válido';

                          if (value.trim().length < 3)
                            return 'Informe um título com no mínimo 3 letras.';

                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _formData['price'].toString(),
                        focusNode: _priceFocusNode,
                        textInputAction: TextInputAction.next,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        onSaved: (newValue) =>
                            _formData['price'] = double.parse(newValue),
                        decoration: InputDecoration(labelText: 'Preço'),
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode),
                        validator: (value) {
                          bool isEmpty = value.trim().isEmpty;
                          var newPrice = double.tryParse(value);
                          bool isInvalid = newPrice == null || newPrice <= 0;
                          if (isEmpty || isInvalid) {
                            return 'Informe um preço válido';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _formData['description'],
                        focusNode: _descriptionFocusNode,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        onSaved: (newValue) =>
                            _formData['description'] = newValue,
                        decoration: InputDecoration(labelText: 'Descrição'),
                        validator: (value) {
                          if (value.trim().isEmpty)
                            return 'Informe uma descricão';

                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              focusNode: _imageURL,
                              controller: _imageUrlController,
                              onSaved: (newValue) =>
                                  _formData['imageUrl'] = newValue,
                              decoration:
                                  InputDecoration(labelText: 'URL da Imagem'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _saveForm(),
                              validator: (value) {
                                if (value.trim().isEmpty) {
                                  return 'Informe uma url válida';
                                }
                                if (!isValidImageUrl(value)) {
                                  return 'Informe uma url válida';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(top: 8, left: 10),
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                              ),
                              child: _imageUrlController.text.isEmpty
                                  ? Text(
                                      'Informe a URL',
                                    )
                                  : Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ))
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}

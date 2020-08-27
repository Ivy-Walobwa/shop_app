import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageController = TextEditingController();
  final _imageFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  Product _editProduct =
      Product(price: 0, id: null, title: '', imageUrl: '', description: '');

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImage);
    super.initState();
  }

  @override
  void dispose() {
    _imageFocusNode.removeListener(_updateImage);
    _descriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    _imageController.dispose();
    _imageFocusNode.dispose();
    super.dispose();
  }

  void _updateImage() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    _form.currentState.save();
    print(_editProduct.title);
    print(_editProduct.description);
    print(_editProduct.imageUrl);
    print(_editProduct.price);
    print(_editProduct.id);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
            key: _form,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  onSaved: (value) {
                    _editProduct = Product(
                      price: _editProduct.price,
                      id: null,
                      title: value,
                      imageUrl: _editProduct.imageUrl,
                      description: _editProduct.description,
                    );
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onSaved: (value){
                    _editProduct = Product(
                      price: double.parse(value),
                      id: null,
                      title: _editProduct.title,
                      imageUrl: _editProduct.imageUrl,
                      description: _editProduct.description,
                    );
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  onSaved: (value){
                    _editProduct = Product(
                      price: _editProduct.price,
                      id: null,
                      title: _editProduct.title,
                      imageUrl: _editProduct.imageUrl,
                      description: value,
                    );
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 100,
                      margin: EdgeInsets.only(
                        top: 8,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      child: _imageController.text.isEmpty
                          ? Text(
                              "Empty Url",
                            )
                          : FittedBox(
                              child: Image.network(_imageController.text),
                              fit: BoxFit.cover,
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image Url'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageController,
                        focusNode: _imageFocusNode,
                        onSaved: (value){
                          _editProduct = Product(
                            price: _editProduct.price,
                            id: null,
                            title: _editProduct.title,
                            imageUrl: value,
                            description: _editProduct.description,
                          );
                        },
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}

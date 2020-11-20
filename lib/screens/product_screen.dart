import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_manager_flutter/blocs/product_bloc.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  final String categoryId;
  final DocumentSnapshot product;

  ProductScreen({this.categoryId, this.product});

  @override
  _ProductScreenState createState() => _ProductScreenState(categoryId, product);
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductBloc _productBloc;
  final _formKey = GlobalKey<FormState>();

  _ProductScreenState(categoryId, product)
      : _productBloc = ProductBloc(categoryId, product);

  @override
  Widget build(BuildContext context) {
    final fieldStyle = TextStyle(color: Colors.white, fontSize: 16);

    InputDecoration _buildDecoration(String label) {
      return InputDecoration(
          labelText: label, labelStyle: TextStyle(color: Colors.grey));
    }

    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        title: Text('Criar produto'),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.remove), onPressed: () {}),
          IconButton(icon: Icon(Icons.save), onPressed: () {})
        ],
      ),
      body: Form(
        key: _formKey,
        child: StreamBuilder<Map>(
            stream: _productBloc.dataOutput,
            builder: (context, productSnapshot) {
              if (!productSnapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
              return ListView(
                padding: EdgeInsets.all(16),
                children: [
                  TextFormField(
                    initialValue: productSnapshot.data['title'],
                    style: fieldStyle,
                    decoration: _buildDecoration('Título'),
                    onSaved: (text) {},
                    validator: (text) {},
                  ),
                  TextFormField(
                    initialValue: productSnapshot.data['description'],
                    style: fieldStyle,
                    decoration: _buildDecoration('Descrição'),
                    maxLines: 6,
                    onSaved: (text) {},
                    validator: (text) {},
                  ),
                  TextFormField(
                    initialValue:
                        productSnapshot.data['price']?.toStringAsFixed(2),
                    style: fieldStyle,
                    decoration: _buildDecoration('Preço'),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    onSaved: (text) {},
                    validator: (text) {},
                  ),
                ],
              );
            }),
      ),
    );
  }
}

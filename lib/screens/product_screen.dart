import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_manager_flutter/blocs/product_bloc.dart';
import 'package:ecommerce_manager_flutter/screens/widgets/images_widget.dart';
import 'package:ecommerce_manager_flutter/validators/product_validator.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  final String categoryId;
  final DocumentSnapshot product;

  ProductScreen({this.categoryId, this.product});

  @override
  _ProductScreenState createState() => _ProductScreenState(categoryId, product);
}

class _ProductScreenState extends State<ProductScreen> with ProductValidator {
  final ProductBloc _productBloc;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _ProductScreenState(categoryId, product)
      : _productBloc = ProductBloc(categoryId, product);

  _saveProduct() async {
    if (_formKey.currentState.validate()) {
      //chama todos os onSave dos componentes FormField de dentro do Form
      _formKey.currentState.save();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Salvando produto...',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(minutes: 1),
        backgroundColor: Colors.pinkAccent,
      ));

      bool success = await _productBloc.saveProduct();

      _scaffoldKey.currentState.removeCurrentSnackBar();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          success ? 'Produto Salvo' : 'Erro ao salvar produto',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pinkAccent,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final fieldStyle = TextStyle(color: Colors.white, fontSize: 16);

    InputDecoration _buildDecoration(String label) {
      return InputDecoration(
          labelText: label, labelStyle: TextStyle(color: Colors.grey));
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        title: StreamBuilder<bool>(
            initialData: false,
            stream: _productBloc.createdOutput,
            builder: (context, createdSnapshot) {
              return Text(
                  createdSnapshot.data ? 'Editar produto' : 'Criar produto');
            }),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                _productBloc.deleteProduct();
                Navigator.of(context).pop();
              }),
          StreamBuilder<bool>(
              initialData: false,
              stream: _productBloc.loadingOutput,
              builder: (context, loadingSnapshot) {
                return IconButton(
                    icon: Icon(Icons.save),
                    onPressed: loadingSnapshot.data ? null : _saveProduct);
              })
        ],
      ),
      body: Stack(
        children: [
          Form(
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
                      Text(
                        'Imagens',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      ImagesWidget(
                        initialValue: productSnapshot.data['images'],
                        context: context,
                        onSaved: _productBloc.saveImages,
                        validator: validateImages,
                      ),
                      TextFormField(
                        initialValue: productSnapshot.data['title'],
                        style: fieldStyle,
                        decoration: _buildDecoration('Título'),
                        onSaved: _productBloc.saveTitle,
                        validator: validateTitle,
                      ),
                      TextFormField(
                        initialValue: productSnapshot.data['description'],
                        style: fieldStyle,
                        decoration: _buildDecoration('Descrição'),
                        maxLines: 6,
                        onSaved: _productBloc.saveDescription,
                        validator: validateDescription,
                      ),
                      TextFormField(
                        initialValue:
                            productSnapshot.data['price']?.toStringAsFixed(2),
                        style: fieldStyle,
                        decoration: _buildDecoration('Preço'),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        onSaved: _productBloc.savePrice,
                        validator: validatePrice,
                      ),
                    ],
                  );
                }),
          ),
          StreamBuilder<bool>(
              stream: _productBloc.loadingOutput,
              initialData: false,
              builder: (context, loadingSnapshot) {
                return IgnorePointer(
                  ignoring: !loadingSnapshot.data,
                  child: Container(
                    color: loadingSnapshot.data
                        ? Colors.black54
                        : Colors.transparent,
                  ),
                );
              }),
        ],
      ),
    );
  }
}

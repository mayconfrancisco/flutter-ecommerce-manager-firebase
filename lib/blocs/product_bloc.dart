import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc extends BlocBase {
  final String categoryId;
  final DocumentSnapshot product;

  final _dataController = BehaviorSubject<Map>();
  Stream<Map> get dataOutput => _dataController.stream;

  Map<String, dynamic> _unsavedData;

  ProductBloc(this.categoryId, this.product) {
    if (product != null) {
      _unsavedData = Map.of(product.data);
      _unsavedData['images'] = List.of(product.data['images']);
      _unsavedData['sizes'] = List.of(product.data['sizes']);
    } else {
      _unsavedData = {
        'title': null,
        'description': null,
        'price': null,
        'images': null,
        'sizes': null,
      };
    }
    _dataController.add(_unsavedData);
  }

  @override
  void dispose() {
    _dataController.close();
  }
}

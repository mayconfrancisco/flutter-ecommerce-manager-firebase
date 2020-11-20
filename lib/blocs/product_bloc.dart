import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc extends BlocBase {
  final String categoryId;
  final DocumentSnapshot product;

  final _dataController = BehaviorSubject<Map>();
  Stream<Map> get dataOutput => _dataController.stream;

  final _loadingController = BehaviorSubject<bool>();
  Stream<bool> get loadingOutput => _loadingController.stream;

  final _createdController = BehaviorSubject<bool>();
  Stream<bool> get createdOutput => _createdController.stream;

  Map<String, dynamic> _unsavedData;

  ProductBloc(this.categoryId, this.product) {
    if (product != null) {
      _unsavedData = Map.of(product.data);
      _unsavedData['images'] = List.of(product.data['images']);
      // _unsavedData['sizes'] = List.of(product.data['sizes']);

      _createdController.add(true);
    } else {
      _unsavedData = {
        'title': null,
        'description': null,
        'price': null,
        'images': null,
        'sizes': null,
      };
      _createdController.add(false);
    }
    _dataController.add(_unsavedData);
  }

  void saveTitle(String title) {
    _unsavedData['title'] = title;
  }

  void saveDescription(String description) {
    _unsavedData['description'] = description;
  }

  void savePrice(String price) {
    _unsavedData['price'] = double.parse(price);
  }

  void saveImages(List images) {
    _unsavedData['images'] = images;
  }

  Future<bool> saveProduct() async {
    _loadingController.add(true);
    try {
      if (product != null) {
        await _uploadImages(product.documentID);
        await product.reference.updateData(_unsavedData);
      } else {
        DocumentReference newProductDr = await Firestore.instance
            .collection('products')
            .document(categoryId)
            .collection('items')
            .add(Map.from(_unsavedData)..remove('images'));
        await _uploadImages(newProductDr.documentID);
        await newProductDr.updateData(_unsavedData);
      }
      _createdController.add(true);
      _loadingController.add(false);
      return true;
    } catch (e) {
      print(e);
      _loadingController.add(false);
      return false;
    }
  }

  void deleteProduct() {
    product.reference.delete();
  }

  Future _uploadImages(String productId) async {
    for (int i = 0; i < _unsavedData['images'].length; i++) {
      if (_unsavedData['images'][i] is String) continue;

      StorageUploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child(categoryId)
          .child(productId)
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(_unsavedData['images'][i]);

      StorageTaskSnapshot uploadSnapshot = await uploadTask.onComplete;
      String imgUrl = await uploadSnapshot.ref.getDownloadURL();

      _unsavedData['images'][i] = imgUrl;
    }
  }

  @override
  void dispose() {
    _dataController.close();
    _loadingController.close();
    _createdController.close();
  }
}

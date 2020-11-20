import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_manager_flutter/screens/product_screen.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final DocumentSnapshot category;

  CategoryTile(this.category);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(category.data['icon']),
            backgroundColor: Colors.transparent,
          ),
          title: Text(
            category.data['title'],
            style:
                TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500),
          ),
          children: [
            FutureBuilder(
                future: category.reference.collection('items').getDocuments(),
                builder: (context, itemsSnapshot) {
                  if (!itemsSnapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    );
                  return Column(
                    children: itemsSnapshot.data.documents
                        .map<Widget>((doc) => ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                backgroundImage:
                                    NetworkImage(doc.data['images'][0]),
                              ),
                              title: Text(doc.data['title']),
                              trailing: Text(
                                  'R\$${doc.data["price"].toStringAsFixed(2)}'),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ProductScreen(
                                          categoryId: category.documentID,
                                          product: doc,
                                        )));
                              },
                            ))
                        .toList()
                          ..add(ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                Icons.add,
                                color: Colors.pinkAccent,
                              ),
                            ),
                            title: Text('Adicionar'),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProductScreen(
                                        categoryId: category.documentID,
                                      )));
                            },
                          )),
                  );
                })
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_manager_flutter/screens/widgets/order_header.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  final DocumentSnapshot order;
  final states = [
    '',
    'Em preparação',
    'Em transporte',
    'Aguardando entrega',
    'Entregue'
  ];
  OrderTile(this.order);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          title: Text(
            '#${order.documentID} - ${states[order["status"]]}',
            style: TextStyle(
                color: order['status'] != 4 ? Colors.grey[600] : Colors.green),
          ),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OrderHeader(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: order['products']
                        .map<Widget>((p) => ListTile(
                              title: Text(
                                  p['product']['title'] + " - " + p['size']),
                              subtitle: Text(p['category'] + "/" + p['pid']),
                              trailing: Text(
                                p['quantity'].toString(),
                                style: TextStyle(fontSize: 20),
                              ),
                              contentPadding: EdgeInsets.zero,
                            ))
                        .toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FlatButton(
                          onPressed: () {},
                          textColor: Colors.red,
                          child: Text('Excluir')),
                      FlatButton(
                          onPressed: () {},
                          textColor: Colors.grey[850],
                          child: Text('Regredir')),
                      FlatButton(
                          onPressed: () {},
                          textColor: Colors.green,
                          child: Text('Avançar')),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

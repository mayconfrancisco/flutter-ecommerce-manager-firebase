import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_manager_flutter/blocs/user_bloc.dart';
import 'package:flutter/material.dart';

class OrderHeader extends StatelessWidget {
  final DocumentSnapshot orderHeader;

  OrderHeader(this.orderHeader);

  @override
  Widget build(BuildContext context) {
    final _userBloc = BlocProvider.of<UserBloc>(context);
    final _user = _userBloc.getUser(orderHeader.data['clientId']);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _user['name'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                _user['address'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Produtos: R\$${orderHeader.data["productsPrice"].toStringAsFixed(2)}',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              'Total: R\$${orderHeader.data["totalPrice"].toStringAsFixed(2)}',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        )
      ],
    );
  }
}

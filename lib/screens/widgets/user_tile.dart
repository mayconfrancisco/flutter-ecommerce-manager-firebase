import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserTile extends StatelessWidget {
  final Map<String, dynamic> user;

  UserTile(this.user);

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(color: Colors.white);

    if (user.containsKey('money')) {
      return ListTile(
        title: Text(
          user['name'],
          style: style,
        ),
        subtitle: Text(
          user['email'],
          style: style,
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Pedidos: ${user["orders"]}',
              style: style,
            ),
            Text(
              'Gasto: R\$${user["money"].toStringAsFixed(2)}',
              style: style,
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
            width: 200,
            child: Shimmer.fromColors(
                child: Container(
                  color: Colors.white.withAlpha(50),
                  margin: EdgeInsets.symmetric(vertical: 4),
                ),
                baseColor: Colors.white,
                highlightColor: Colors.grey),
          ),
          SizedBox(
            height: 20,
            width: 350,
            child: Shimmer.fromColors(
                child: Container(
                  color: Colors.white.withAlpha(50),
                  margin: EdgeInsets.symmetric(vertical: 4),
                ),
                baseColor: Colors.white,
                highlightColor: Colors.grey),
          )
        ],
      ),
    );
  }
}

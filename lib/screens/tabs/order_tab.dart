import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:ecommerce_manager_flutter/blocs/order_bloc.dart';
import 'package:ecommerce_manager_flutter/screens/widgets/order_tile.dart';
import 'package:flutter/material.dart';

class OrderTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final OrderBloc _orderBloc = BlocProvider.of<OrderBloc>(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: StreamBuilder<List>(
          stream: _orderBloc.ordersOutput,
          builder: (context, ordersSnapshot) {
            if (!ordersSnapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
                ),
              );
            } else if (ordersSnapshot.data.length == 0) {
              return Center(
                child: Text(
                  'Nenhum pedido encontrado!',
                  style: TextStyle(color: Colors.pinkAccent),
                ),
              );
            }
            return ListView.builder(
                itemCount: ordersSnapshot.data.length,
                itemBuilder: (context, index) {
                  return OrderTile(ordersSnapshot.data[index]);
                });
          }),
    );
  }
}

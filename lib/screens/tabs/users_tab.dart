import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:ecommerce_manager_flutter/blocs/user_bloc.dart';
import 'package:ecommerce_manager_flutter/screens/widgets/user_tile.dart';
import 'package:flutter/material.dart';

class UsersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userBloc = BlocProvider.of<UserBloc>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                hintText: 'Pesquisar',
                hintStyle: TextStyle(color: Colors.white),
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                border: InputBorder.none),
          ),
        ),
        Expanded(
            child: StreamBuilder<List>(
                stream: _userBloc.usersOutput,
                builder: (context, usersSnapshot) {
                  if (!usersSnapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    );
                  } else if (usersSnapshot.data.length == 0) {
                    return Center(
                      child: Text(
                        'Nenhum usuário encontrado',
                        style: TextStyle(color: Colors.pinkAccent),
                      ),
                    );
                  } else {
                    return ListView.separated(
                        itemBuilder: (context, index) {
                          return UserTile(usersSnapshot.data[index]);
                        },
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                        itemCount: usersSnapshot.data.length);
                  }
                }))
      ],
    );
  }
}

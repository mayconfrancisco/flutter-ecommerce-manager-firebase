import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:ecommerce_manager_flutter/blocs/order_bloc.dart';
import 'package:ecommerce_manager_flutter/blocs/user_bloc.dart';
import 'package:ecommerce_manager_flutter/screens/tabs/order_tab.dart';
import 'package:ecommerce_manager_flutter/screens/tabs/users_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;
  int _currentPage = 0;
  UserBloc _userBloc;
  OrderBloc _orderBloc;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _userBloc = UserBloc();
    _orderBloc = OrderBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: SafeArea(
        child: BlocProvider<UserBloc>(
          bloc: _userBloc,
          child: BlocProvider<OrderBloc>(
            bloc: _orderBloc,
            child: PageView(
              controller: _pageController,
              onPageChanged: (p) {
                setState(() {
                  _currentPage = p;
                });
              },
              children: [
                UsersTab(),
                OrderTab(),
                Container(
                  color: Colors.yellow,
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.pinkAccent,
          primaryColor: Colors.white,
          // textTheme: Theme.of(context).textTheme.copyWith(
          //       caption: TextStyle(color: Colors.white),
          //     )
        ),
        child: BottomNavigationBar(
          currentIndex: _currentPage,
          onTap: (p) {
            _pageController.animateToPage(p,
                duration: Duration(milliseconds: 300), curve: Curves.ease);
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: 'Clientes'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), label: 'Pedidos'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Produtos'),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    switch (_currentPage) {
      case 0:
        return null;
      case 1:
        return SpeedDial(
          child: Icon(Icons.sort),
          backgroundColor: Colors.pinkAccent,
          overlayOpacity: 0.4,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
              child: Icon(
                Icons.arrow_downward,
                color: Colors.pinkAccent,
              ),
              backgroundColor: Colors.white,
              label: 'Concluídos abaixo',
              labelStyle: TextStyle(fontSize: 14),
              onTap: () {
                _orderBloc.setSortCriteria(SortCriteria.READY_LAST);
              },
            ),
            SpeedDialChild(
                child: Icon(
                  Icons.arrow_upward,
                  color: Colors.pinkAccent,
                ),
                backgroundColor: Colors.white,
                label: 'Concluídos acima',
                labelStyle: TextStyle(fontSize: 14),
                onTap: () {
                  _orderBloc.setSortCriteria(SortCriteria.READY_FIRST);
                }),
          ],
        );
      default:
        return null;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}

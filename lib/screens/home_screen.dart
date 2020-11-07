import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: PageView(
        controller: _pageController,
        onPageChanged: (p) {
          setState(() {
            _currentPage = p;
          });
        },
        children: [
          Container(
            color: Colors.red,
          ),
          Container(
            color: Colors.green,
          ),
          Container(
            color: Colors.yellow,
          )
        ],
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
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}


import 'package:flutter/material.dart';
import 'package:kissanpay/Hom.dart';
import 'package:kissanpay/history.dart';
import 'package:kissanpay/mall.dart';
import 'package:kissanpay/profile/profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var _screens = [ HomScreen(), MallScreen(), HistoryScreen(), ProfileScreen() ];
  int _selecteditem = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _screens[_selecteditem],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.black,), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shop, color: Colors.black,), label: "Mall"),
          BottomNavigationBarItem(icon: Icon(Icons.history, color: Colors.black,), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.person, color: Colors.black,), label: "Profile"),

        ],
        currentIndex: _selecteditem,
        onTap: (setValue){
          setState(() {
            _selecteditem = setValue;
          });

        },
      ),
    );
  }
}

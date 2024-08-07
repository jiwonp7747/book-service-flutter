import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _menuIndex=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(""),
        centerTitle: true,

      ),

      body: IndexedStack(
        index: _menuIndex,
        children: [
          Container(
            color: Colors.red,
          ),
          Container(
            color: Colors.blue,
          )
          //HomeWidget(), // index : 0
          //SellerWidget(),
        ],
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _menuIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _menuIndex = idx;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.store_outlined),
            label: "홈",
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront),
            label: "판매자",
          ),
        ],
      ),


    );
  }
}

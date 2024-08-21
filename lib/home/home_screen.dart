import 'package:book_service_flutter/login/login_service.dart';
import 'package:book_service_flutter/home/widget/market_screen.dart';
import 'package:book_service_flutter/home/widget/sell_book_screen.dart';
import 'package:book_service_flutter/profile/user_profile_screen.dart';
import 'package:book_service_flutter/review/review_board_screen.dart';
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
      /*appBar: AppBar(
        title: Text(""),
        centerTitle: true,

      ),*/
      body: IndexedStack(
        index: _menuIndex,
        children: [
          MarketScreen(),
          SellBookScreen(),
          ReviewBoardScreen(),
          LoginService(),
          UserProfileScreen(),
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
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: "홈",
          ),
          NavigationDestination(
            icon: Icon(Icons.chat),
            label: "채팅",
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_on),
            label: "게시판",
          ),
          NavigationDestination(
            icon: Icon(Icons.diamond),
            label: "추천",
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: "정보",
          ),
        ],
      ),


    );
  }
}

import 'package:book_service_flutter/login/login_service.dart';
import 'package:book_service_flutter/home/widget/market_screen.dart';
import 'package:book_service_flutter/login/register_success.dart';
import 'package:book_service_flutter/login/register_user.dart';
import 'package:flutter/material.dart';
import 'package:book_service_flutter/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookSwap',
      theme: ThemeData(

      ),
      home: HomeScreen(),
    );
  }
}



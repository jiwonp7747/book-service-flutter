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



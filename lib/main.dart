import 'package:book_service_flutter/login/login_service.dart';
import 'package:book_service_flutter/home/widget/market_screen.dart';
import 'package:book_service_flutter/login/register_success.dart';
import 'package:book_service_flutter/login/register_user.dart';
import 'package:flutter/material.dart';
import 'package:book_service_flutter/home/home_screen.dart';
import 'dart:async';
import 'dart:developer';
import 'package:flutter_naver_map/flutter_naver_map.dart';

void main() async{
  await _initialize();
  runApp(const MyApp());
}

// 지도 초기화하기
Future<void> _initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
      clientId: '<client id>',     // 클라이언트 ID 설정
      onAuthFailed: (e) => log("네이버맵 인증오류 : $e", name: "onAuthFailed")
  );
}

class MyApp extends StatelessWidget{
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookSwap',
      theme: ThemeData(

      ),
      home: LoginService(),
    );
  }
}



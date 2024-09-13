import 'package:book_service_flutter/login/login_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:developer';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:intl/date_symbol_data_local.dart'; // 날짜 형식을 위한 로컬 데이터
import 'package:flutter_localizations/flutter_localizations.dart'; // flutter_localizations import

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await _initialize();
  await initializeDateFormatting('ko_KR', null);
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
      locale: Locale('ko', 'KR'), // 앱에서 한국어를 기본 로케일로 설정
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ko', 'KR'), // 한국어 로케일 추가
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],

      title: 'BookSwap',
      theme: ThemeData(

      ),
      home: LoginService(),
    );
  }
}



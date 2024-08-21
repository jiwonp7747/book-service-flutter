import 'package:flutter/material.dart';

class SettingUserScreen extends StatefulWidget {
  const SettingUserScreen({super.key});

  @override
  State<SettingUserScreen> createState() => _SettingUserScreenState();
}

class _SettingUserScreenState extends State<SettingUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.grey[200],
            child: Column(
              children: const [
                ListTile(
                  title: Text('알림 수신 설정'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                Divider(height: 1, color: Colors.grey),
                ListTile(
                  title: Text('위치기반 서비스 이용약관'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                Divider(height: 1, color: Colors.grey),
                ListTile(
                  title: Text('공지사항'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20,),
          // 두 번째 설정 섹션
          Container(
            color: Colors.grey[200],
            child: Column(
              children: const [
                ListTile(
                  title: Text('로그아웃'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                Divider(height: 1, color: Colors.grey),
                ListTile(
                  title: Text('탈퇴하기'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:book_service_flutter/config/config.dart';
import 'package:book_service_flutter/profile/setting_user_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String userName = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _fetchUserProfile() async {
    final url = Uri.parse('${Config.baseUrl}/api/user?id=2'); // 서버 URL 변경
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'authorization-token': Config.accessToken, // 토큰을 헤더에 추가
        },
      );

      if (response.statusCode == 200) {
        // 서버로부터 받은 응답을 디코딩하여 JSON 데이터를 추출
        //return jsonDecode(utf8.decode(response.bodyBytes));
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        // 서버로부터의 응답이 오류인 경우 처리
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('프로필 정보를 가져오지 못했습니다.')),
        );
        throw Exception('Failed to load profile data'); // 오류 발생 시 예외 던짐
      }
    } catch (e) {
      // 네트워크 또는 기타 오류 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류 발생: $e')),
      );
      throw Exception('Failed to load profile data'); // 오류 발생 시 예외 던짐
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.grey,
            ),
            onPressed: () {
              // 설정 페이지 이동 처리
              Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>SettingUserScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
      child: FutureBuilder<Map<String, dynamic>>(
    future: _fetchUserProfile(), // HTTP 요청 실행
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // 데이터 로딩 중일 때
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        // 오류가 발생한 경우
        return Center(child: Text('오류: ${snapshot.error}'));
      } else if (snapshot.hasData) {
        // 데이터 로드 완료된 경우
        final data = snapshot.data!;
        final userName = data['nickname'];

        return Column(
          children: [
            // 사용자 정보 영역
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // 프로필 이미지 및 레벨
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: AssetImage('assets/images/img.png'),
                    //backgroundImage: NetworkImage(profileImage), // 서버로부터 받은 프로필 이미지 사용
                  ),
                  const SizedBox(width: 16),
                  // 사용자 이름 및 포인트
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('0 포인트', style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // 탭바 영역
            TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.black,
              tabs: const [
                Tab(text: '판매 내역'),
                Tab(text: '구매 내역'),
                Tab(text: '리뷰 게시글'),
              ],
            ),
            // 탭바의 내용 영역
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTransactionList(),
                  const Center(child: Text('구매 내역')),
                  const Center(child: Text('리뷰 게시글')),
                ],
              ),
            ),
          ],
        );
      } else {
        // 데이터가 없는 경우 (예: 서버 응답이 null인 경우)
        return const Center(child: Text('데이터를 불러올 수 없습니다.'));
      }
    },
    ),
    ),
    );
  }

  // 판매 내역 리스트뷰 생성
  Widget _buildTransactionList() {
    return ListView.builder(
      itemCount: 3, // 예시로 3개의 항목을 리스트로 표시
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          leading: Container(
            width: 60,
            height: 60,
            color: Colors.grey[300],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('24.08.05 (월)'),
              const Text('책 제목'),
              Text("10,000원"),
            ],
          ),
        );
      },
    );
  }
}


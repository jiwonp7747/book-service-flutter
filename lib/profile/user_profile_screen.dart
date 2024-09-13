import 'package:book_service_flutter/profile/setting_user_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:book_service_flutter/config/config.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
    final url = Uri.parse('${Config.baseUrl}/api/user');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'authorization-token': Config.accessToken,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception('프로필 요청 오류 catch');
      }
    } catch (e) {
      throw Exception('프로필 요청 중 오류 catch ');
    }
  }

  Future<List<dynamic>> _fetchUserPosts() async {
    final url = Uri.parse('${Config.baseUrl}/api/post/get-list/user');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'authorization-token': Config.accessToken,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception('Failed to load user posts statuscode');
      }
    } catch (e) {
      throw Exception('Failed to load user posts catch');
    }
  }

  Widget _buildNetworkImage(String imageUrl) {
    final startTime = DateTime.now();
    return Image.network(
      Config.baseUrl + imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          final endTime = DateTime.now();
          final loadTime = endTime.difference(startTime).inMilliseconds;
          print('NetworkImage loaded in $loadTime ms');
          return child;
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return Icon(Icons.error);
      },
    );
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingUserScreen()));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder<Map<String, dynamic>>(
              future: _fetchUserProfile(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('오류: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  final userName = data['nickname'];

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[200],
                          backgroundImage:
                              const AssetImage('assets/images/img.png'),
                        ),
                        const SizedBox(width: 16),
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
                              const Text('0 포인트',
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: Text('사용자 정보를 불러올 수 없습니다.'));
                }
              },
            ),
            TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.black,
              tabs: const [
                Tab(text: '등록된 책'),
                Tab(text: '구매 내역'),
                Tab(text: '리뷰 게시글'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // children 순으로 1, 2, 3  control
                  FutureBuilder<List<dynamic>>(
                    future: _fetchUserPosts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('오류: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        final posts = snapshot.data!;
                        return GridView.builder(
                          padding: const EdgeInsets.all(16.0),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post =
                                posts[index] as Map<String, dynamic>; // 타입 캐스팅
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    // 책 이미지
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ), // BoxDecoration의 닫는 괄호
                                  child: post['image_url'] != null ||
                                          post['image_url'].isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: Config.baseUrl +
                                              post['image_url'],
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        )
                                      : Icon(
                                          Icons.image,
                                          size: 30,
                                          color: Colors.grey[700],
                                        ),
                                ),
                                const SizedBox(height: 8),
                                //Text(post['image_url'] ?? 'Unknown Date'),
                                Text(post['title'] ?? 'Unknown Title'),
                                Text("${post['price'] ?? 'Unknown Price'}원"),
                              ],
                            );
                          },
                        );
                      } else {
                        return const Center(child: Text('게시물을 불러올 수 없습니다.'));
                      }
                    },
                  ),
                  Column(
                    children: [
                      Text('리뷰 게시글'),
                      Text('리뷰 게시글'),
                    ],
                  ),
                  const Center(child: Text('리뷰 게시글')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

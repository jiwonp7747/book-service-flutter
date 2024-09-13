import 'package:book_service_flutter/config/config.dart';
import 'package:book_service_flutter/home/widget/book_detail_screen.dart';
import 'package:book_service_flutter/home/widget/sell_book_screen.dart';
import 'package:book_service_flutter/map/naver_map.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:book_service_flutter/home/class/post.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  List<Post> allPosts = []; // 전체 게시물 리스트
  List<Post> filteredPosts = []; // 필터링된 게시물 리스트
  TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    fetchPosts();
    searchController.addListener(_updateSuffixIcon); // 필드의 내용이 변경될 때 실행될 리스너
    focusNode.addListener(_updateSuffixIcon);  // 포커스 변경될 때 마다 실행될 리스너
  }

  @override
  void dispose() {
    searchController.dispose();
    focusNode.dispose();  // FocusNode 해제
    super.dispose();
  }

  Future<void> fetchPosts() async {
    final response = await http.get(
      Uri.parse('${Config.baseUrl}/api/post/get-list'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization-token': Config.accessToken,
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        allPosts = jsonResponse.map((post) => Post.fromJson(post)).toList();
        filteredPosts = allPosts;
      });
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> refreshPosts() async {
    await fetchPosts();
  }

  // 검색어 또는 focus 상태에 따라 suffixIcon을 업데이트
  void _updateSuffixIcon() {
    setState(() {});
  }

  // 검색어에 따라 게시물을 필터링하는 함수
  void filterPosts(String query) {
    if (query.isEmpty) {
      // 검색어가 없으면 전체 게시물을 보여줌
      setState(() {
        filteredPosts = allPosts;
      });
    } else {
      // 검색어가 있을 때 게시물 제목에 해당 검색어가 포함된 게시물만 필터링
      setState(() {
        filteredPosts = allPosts
            .where((post) =>
                post.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 8,
            ),
            Text(
              'BOOKSWAP',
              style: TextStyle(
                  color: Color(0xFF53787E),
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            child: const Row(
              children: [
                Icon(
                  Icons.settings,
                  color: Colors.grey,
                ),
                Text(
                  " 범위 설정",
                  style: TextStyle(),
                ),
                SizedBox(
                  width: 16,
                ),
              ],
            ),
            onTap: () async {
              await initialize();
              final resultRange = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const NaverMap()));
            },
          )
        ],
        toolbarHeight: 80,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField( // 검색 기능
              controller: searchController,
              onChanged: filterPosts,
              focusNode: focusNode, // 포커스 설정
              decoration: InputDecoration(
                hintText: '검색',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFF53787E),
                ),
                suffixIcon: focusNode.hasFocus // 포커스 되었을 때 취소 버튼 생성
                    ? IconButton(onPressed: () {
                      searchController.clear(); // 텍스트 비운 후
                      filterPosts(''); // '' 전체 글 다시 불러 오기
                      focusNode.unfocus(); // 포커스 해제
                }, icon: Icon(Icons.cancel))
                    : Container(),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: refreshPosts,
              child: filteredPosts.isEmpty
                  ? Center(
                      child: Text('No posts available.'),
                    )
                  : ListView.builder(
                      itemCount: filteredPosts.length,
                      itemBuilder: (context, index) {
                        final post = filteredPosts[index];
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 1.0, horizontal: 16.0),
                            child: GestureDetector(
                              onTap: () {
                                print("카드가 눌렸습니다." + post.title);
                                print("카드가 눌렸습니다. ${Config.accessToken}");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BookDetailScreen(
                                              post: post,
                                            )));
                              },
                              child: Card(
                                //color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 16),
                                  leading: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      // 책 이미지
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(10),
                                    ), // BoxDecoration의 닫는 괄호

                                    child: post.imageUrl != null &&
                                            post.imageUrl.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: _buildCachedNetworkImage(
                                                post.imageUrl),
                                          )
                                        : Icon(
                                            Icons.image,
                                            size: 30,
                                            color: Colors.grey[700],
                                          ),
                                  ), // Container의 닫는 괄호
                                  title: Text(
                                    post.title,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ), // Text의 닫는 괄호
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //Text(post.title),
                                      //SizedBox(height: 4),
                                      Text(
                                        "${post.price.toString()}원",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      SizedBox(height: 4),
                                      Text(post.content),
                                    ], // Column의 children 닫는 괄호
                                  ), // ListTile의 닫는 괄호
                                ),
                              ),
                            ),
                          ),
                        ); // ListView.builder의 닫는 괄호
                      },
                    ),
            ),
          ), // Expanded의 닫는 괄호
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'homeTag1',
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SellBookScreen()),
          );
          //글이 성공적으로 등록되었으면
          if (result == true) {
            print("이미지 게시 성공입니다.");
            refreshPosts();
          }
        },
        label: Text(
          '책 등록',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        icon: Icon(
          Icons.edit,
          color: Colors.white,
        ),
        backgroundColor: Color(0xFF53787E),
      ),
    );
  }

  Widget _buildCachedNetworkImage(String imageUrl) {
    final startTime = DateTime.now();
    return CachedNetworkImage(
      imageUrl: Config.baseUrl + imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
      imageBuilder: (context, imageProvider) {
        final endTime = DateTime.now();
        final loadTime = endTime.difference(startTime).inMilliseconds;
        print('CachedNetworkImage loaded in $loadTime ms');
        return Image(
          image: imageProvider,
          fit: BoxFit.cover,
        );
      },
    );
  }
}

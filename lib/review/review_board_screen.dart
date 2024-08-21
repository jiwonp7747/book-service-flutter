import 'package:book_service_flutter/config/config.dart';
import 'package:book_service_flutter/home/class/post.dart';
import 'package:book_service_flutter/home/widget/book_detail_screen.dart';
import 'package:book_service_flutter/home/widget/sell_book_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import "dart:convert";

class ReviewBoardScreen extends StatefulWidget {
  const ReviewBoardScreen({super.key});

  @override
  State<ReviewBoardScreen> createState() => _ReviewBoardScreenState();
}

class _ReviewBoardScreenState extends State<ReviewBoardScreen> {
  Future<List<Post>> fetchPosts() async {
    final response = await http.get(
      Uri.parse('${Config.baseUrl}/api/post/get-list'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization-token': Config.accessToken,
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> refreshPosts() async {
    // 새로운 데이터를 가져오기 위해 fetchPosts를 호출하여 상태를 업데이트합니다.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 8,
            ),
            Text(
              '리뷰 게시판',
              style: TextStyle(
                  color: Colors.teal[700],
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),

        toolbarHeight: 80,
      ),

      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                  hintText: '검색',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200]),
            ),
          ),
          SizedBox(height: 16,),
          Expanded(
            child: RefreshIndicator(
              onRefresh: refreshPosts,
              child: FutureBuilder<List<Post>>(
                future: fetchPosts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No posts available.'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data![index];
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 16.0),
                            child: GestureDetector(
                              onTap: (){
                                print("카드가 눌렸습니다."+post.title);
                                print("카드가 눌렸습니다. ${Config.accessToken}");
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context)=>BookDetailScreen(post: post,))
                                );
                              }, //TODO 카드를 눌렀을 때 상세페이지
                              child: Card( //TODO 카드 사이즈 조절
                                //color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ), // RoundedRectangleBorder의 닫는 괄호
                                child: ListTile(
                                  leading: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration( // 책 이미지
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(10),
                                      image: post.imageUrl != null && post.imageUrl.isNotEmpty
                                          ? DecorationImage(
                                        image: NetworkImage(Config.baseUrl+post.imageUrl), // 네트워크에서 이미지를 로드
                                        fit: BoxFit.cover, // 이미지를 Container의 크기에 맞게 조정
                                      )
                                          : null, // 이미지가 없으면 DecorationImage를 null로 설
                                    ), // BoxDecoration의 닫는 괄호

                                    child: post.imageUrl == null || post.imageUrl.isEmpty
                                        ? Icon(
                                      Icons.image,
                                      size: 30,
                                      color: Colors.grey[700], // 기본 아이콘 색상
                                    )
                                        : null, // 이미지가 있으면 아이콘을 표시하지 않음
                                  ), // Container의 닫는 괄호
                                  title: Text(
                                    post.title,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ), // Text의 닫는 괄호
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      //Text(post.title),
                                      //SizedBox(height: 4),
                                      Text(
                                        "${post.price.toString()}원",
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                      ),
                                      SizedBox(height: 4),
                                      Text(post.content),
                                    ], // Column의 children 닫는 괄호
                                  ), // subtitle 끝
                                ), // ListTile의 닫는 괄호
                              ),
                            ), // Card의 닫는 괄호
                          ),
                        ); // Padding의 닫는 괄호
                      }, // ListView.builder의 itemBuilder 닫는 괄호
                    ); // ListView.builder의 닫는 괄호
                  } // if-else 닫는 괄호
                }, // FutureBuilder의 builder 닫는 괄호
              ),
            ), // FutureBuilder의 닫는 괄호
          ), // Expanded의 닫는 괄호
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result= await Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=>const SellBookScreen()),
          );
          //글이 성공적으로 등록되었으면
          if(result==true){
            print("리뷰글 게시 성공입니다.");
            refreshPosts();
          }
        },
        label: Text('글쓰기',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
        ),
        icon: Icon(Icons.edit, color: Colors.white,),
        backgroundColor: Colors.teal,
      ),
    );
  }
}

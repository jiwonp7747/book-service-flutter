import 'package:book_service_flutter/chat/chat_detail_screen.dart';
import 'package:book_service_flutter/config/config.dart';
import 'package:book_service_flutter/home/class/post.dart';
import 'package:book_service_flutter/home/widget/exchange_request.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BookDetailScreen extends StatefulWidget {
  final Post post;

  const BookDetailScreen({super.key, required this.post});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  int heartSelected=0;

  Future<void> registerChatRoom() async { // 채팅하기 버튼 누를 시 채팅방 만들기

    try {
      var uri=Uri.parse('${Config.baseUrl}/api/chat-room');
      // JSON 데이터 준비
      var body = jsonEncode({
        'post_id': widget.post.id,
      });

      // POST 요청 수행
      var response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization-token': Config.accessToken,
        },
        body: body,
      );

      if (response.statusCode == 200) {

        var responseData=jsonDecode(response.body);
        var chatRoomId=responseData['id'];

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('채팅방이 성공적으로 등록되었습니다.')),
        );
        /*Navigator.push(context,
            MaterialPageRoute(builder: (context)=>ChatDetailScreen(chatRoomId: chatRoomId, ,))
        );*/
      } else {
        // 오류 처리
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('채팅방 등록에 실패하였습니다.')),
        );
      }
    } catch (e) {
      // 네트워크 또는 기타 오류 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류 발생: $e')),
      );
    }
  }

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.teal[300],
                    child: Text(
                      widget.post.title[0], // 닉네임의 첫 글자를 아바타로 표시
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  SizedBox(width: 6,),
                  Column(
                    children: [
                      Text("닉네임",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("3분전"),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                width: double.infinity,
                height: 400,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: NetworkImage(
                      Config.baseUrl + widget.post.imageUrl),
                  fit: BoxFit.cover,
                )),
              ),
              SizedBox(
                height: 16,
              ),
              Text("무슨구 무슨동"),
              SizedBox(
                height: 8,
              ),
              Text(widget.post.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ), //TODO post title
              Text("${widget.post.price.toString()}원",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ), //TODO post price
              SizedBox(
                height: 24,
              ),
              Text(
                widget.post.content,
              ),
              SizedBox(
                height: 24,
              ),

              Divider(),
              Text("교환 제안", style: TextStyle(
                fontWeight: FontWeight.bold
              ),),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            IconButton( //TODO 하트처리 색상 처리는 완료하였으나 데이터베이스 반영 x
                onPressed: (){
                  heartSelected=1-heartSelected;
                  setState(() {
                  });
                },
                icon: Icon(
                  heartSelected==0 ? Icons.favorite_border : Icons.favorite
                  , color: Color(0xFF53787E),
                )
            ),
            SizedBox(width: 8,),
            Expanded(
              child: ElevatedButton(
                  onPressed: () { // TODO 교환 요청
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>ExchangeRequest(post: widget.post,))
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Color(0xFF53787E),
                    minimumSize: Size(double.infinity, 48),
                  ),
                  child: Text("교환요청",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
              ),
            ),
            SizedBox(width: 8,),
            Expanded(
              child: ElevatedButton(
                  onPressed: () { // 채팅방 등록 및 이동
                    registerChatRoom();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Color(0xFF53787E),
                    minimumSize: Size(double.infinity, 48),
                  ),
                  child: Text("채팅하기",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}

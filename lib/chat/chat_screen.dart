import 'package:book_service_flutter/chat/chat_detail_screen.dart';
import 'package:book_service_flutter/chat/class/chat_room.dart';
import 'package:book_service_flutter/config/config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import "dart:convert";

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreen();
}

class _ChatScreen extends State<ChatScreen> {
  List<ChatRoom> chatRoomLists=[];

  @override
  void initState() {
    super.initState();
    fetchChatRooms();
  }

  Future<void> fetchChatRooms() async {
    final response = await http.get(
      Uri.parse('${Config.baseUrl}/api/chat-room/get-list'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization-token': Config.accessToken,
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      chatRoomLists= jsonResponse
          .map((chatRoom) => ChatRoom.fromJson(chatRoom))
          .toList();

      print("chat Room list: "+chatRoomLists[0].anotherUserNickname);
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> refreshPosts() async {
    // 새로운 데이터를 가져오기 위해 fetchPosts를 호출하여 상태를 업데이트합니다.
    await fetchChatRooms();
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
              '채팅',
              style: TextStyle(
                  color: Color(0xFF53787E),
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        toolbarHeight: 80,
      ),
      body: Column(
        children: [

          SizedBox(
            height: 16,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: refreshPosts,
              child: chatRoomLists.isEmpty
                  ? Center(child: Text('No chatRooms available.'),)
              :ListView.builder(
                      itemCount: chatRoomLists.length,
                      itemBuilder: (context, index) {
                        final chatRoom = chatRoomLists[index];
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 1.0, horizontal: 16.0),
                            child: GestureDetector(
                              onTap: () {
                                print("카드가 눌렸습니다." +
                                    chatRoom.anotherUserNickname);
                                print("카드가 눌렸습니다. ${Config.accessToken}");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatDetailScreen(
                                              chatRoom: chatRoom,
                                            )));
                              }, //TODO 카드를 눌렀을 때 상세페이지
                              child: Card(
                                //color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ), // RoundedRectangleBorder의 닫는 괄호
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                  leading: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        // 책 이미지
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(
                                            10), // 이미지가 없으면 DecorationImage를 null로 설
                                      ), // BoxDecoration의 닫는 괄호

                                      child: chatRoom.imageUrl.isNotEmpty
                                          ? CachedNetworkImage(
                                              imageUrl: Config.baseUrl +
                                                  chatRoom.imageUrl,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            )
                                          : Icon(
                                              Icons.image,
                                              size: 30,
                                              color:
                                                  Colors.grey[700], // 기본 아이콘 색상
                                            )), // Container의 닫는 괄호
                                  title: Text(
                                    chatRoom.anotherUserNickname,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ), // Text의 닫는 괄호
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //Text(post.title),
                                      //SizedBox(height: 4),

                                      SizedBox(height: 4),
                                      Text(chatRoom.anotherUserNickname),
                                    ], // Column의 children 닫는 괄호
                                  ), // subtitle 끝
                                ), // ListTile의 닫는 괄호
                              ),
                            ), // Card의 닫는 괄호
                          ),
                        ); // Padding의 닫는 괄호
                    // ListView.builder의 닫는 괄호
                  } // if-else 닫는 괄호
                // FutureBuilder의 builder 닫는 괄호
              ),
            ), // FutureBuilder의 닫는 괄호
          ), // Expanded의 닫는 괄호
        ],
      ),
    );
  }
}

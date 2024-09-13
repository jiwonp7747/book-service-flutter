import 'package:book_service_flutter/chat/class/chat_room.dart';
import 'package:book_service_flutter/config/config.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ChatDetailScreen extends StatefulWidget {
  final ChatRoom chatRoom;

  const ChatDetailScreen({super.key, required this.chatRoom});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  int messageCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchMessages(); // 화면이 로드될 때 메시지를 가져오는 함수 호출
  }

  Future<void> _fetchMessages() async {
    try {
      var uri = Uri.parse('${Config.baseUrl}/api/chat-message/get-list?chat-room-id=${widget.chatRoom.id}');
      var response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization-token': Config.accessToken,
        },
      );

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          messages = jsonResponse.map((message) => {
            'text': message['content'],
            'isMe': message['is_me'], // 이 부분은 서버 응답에 따라 달라질 수 있습니다.
            'time': message['registered_at'],
          }).toList();
          messageCount = messages.length;
        });
      } else {
        throw Exception('Failed to load messages');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch messages: $e')),
      );
    }
  }

  Future<void> _sendMessage(String message) async {
    try {
      var uri = Uri.parse('${Config.baseUrl}/api/chat-message/register');
      var body = jsonEncode({
        'content': message,
        'chat_room_id': widget.chatRoom.id,
      });

      var response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization-token': Config.accessToken,
        },
        body: body,
      );

      if (response.statusCode == 200) {
        setState(() {
          messages.insert(messageCount, {
            'text': message,
            'isMe': true,
            'time': '방금',
          });
          messageCount++;
        });
        _messageController.clear();
      } else {
        throw Exception('Failed to send message');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
    }
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    bool isMe = message['isMe'];
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!isMe)
              CircleAvatar(
                radius: 15,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 15, color: Colors.white),
              ),
            if (!isMe) SizedBox(width: 8),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: isMe ? Colors.grey[200] : Color(0xFF53787E),
                borderRadius: BorderRadius.circular(20),
              ),
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    message['text'],
                    style: TextStyle(
                      color: isMe ? Colors.black : Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    _formatTime(message['time']),
                    style: TextStyle(
                      color: isMe ? Colors.grey : Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isMe) SizedBox(width: 8),
            if (isMe)
              CircleAvatar(
                radius: 15,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 15, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTime(String time) {
    try {
      // 서버에서 받은 시간 데이터를 DateTime으로 변환
      DateTime dateTime = DateTime.parse(time);

      // 원하는 형식으로 포맷팅
      return DateFormat('aa hh:mm', 'ko_KR').format(dateTime); // 원하는 포맷으로 수정 가능
    } catch (e) {
      // 에러 발생 시 원래 시간 문자열 반환
      return time;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                      image: widget.chatRoom.imageUrl != null && widget.chatRoom.imageUrl.isNotEmpty
                          ? DecorationImage(
                        image: NetworkImage(Config.baseUrl+widget.chatRoom.imageUrl), // 네트워크에서 이미지를 로드
                        fit: BoxFit.cover, // 이미지를 Container의 크기에 맞게 조정
                    ):null,
                  ),
                  ),
                  SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.chatRoom.anotherUserNickname,),
                      Text("책 제목제목제목",),
                      Text("10,000원",),
                    ],
                  )
                ],
              ),
              Divider(),
              Expanded(
                child: ListView.builder(
                  reverse: false,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessage(messages[index]);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: '메시지를 입력하세요...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Colors.grey[100],
                          filled: true,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: Color(0xFF53787E),
                      child: IconButton(
                        icon: Icon(Icons.send, color: Colors.white),
                        onPressed: () {
                          if (_messageController.text.trim().isNotEmpty) {
                            _sendMessage(_messageController.text.trim());
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


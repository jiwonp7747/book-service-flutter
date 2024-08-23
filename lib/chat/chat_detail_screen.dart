import 'package:flutter/material.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> messages = [
    {'text': '안녕하세요.', 'isMe': false, 'time': '오전 11:26'},
    {'text': '안녕하세요', 'isMe': true, 'time': '오전 11:26'},
  ];
  int messageCount=2;

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
                    message['time'],
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
                child: Icon(Icons.person, size: 15, color: Colors.white,),
              ),
          ],
        ),
      ),
    );
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
                    ),
                    /*child: post.imageUrl != null && post.imageUrl.isNotEmpty
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: _buildCachedNetworkImage(post.imageUrl),
                    )
                        : Icon(
                      Icons.image,
                      size: 30,
                      color: Colors.grey[700],
                    ),*/
                  ),
                  SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("닉네임",),
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
                          // 메시지 전송 로직 추가
                          setState(() {
                            messages.insert(messageCount, {
                              'text': _messageController.text,
                              'isMe': true,
                              'time': '오전 11:27',
                            });
                            messageCount++;
                            _messageController.clear();
                          });
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

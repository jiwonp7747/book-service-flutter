import 'package:book_service_flutter/config/config.dart';
import 'package:book_service_flutter/home/class/post.dart';
import 'package:flutter/material.dart';

class BookDetailScreen extends StatefulWidget {
  final Post post;

  const BookDetailScreen({super.key, required this.post});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  int heartSelected=0;
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
                  , color: Colors.teal,
                )
            ),
            SizedBox(width: 8,),
            Expanded(
              child: ElevatedButton(
                  onPressed: () {

                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.teal,
                    minimumSize: Size(double.infinity, 48),
                  ),
                  child: Text("채팅하기",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}

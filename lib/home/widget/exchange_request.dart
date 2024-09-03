import 'package:book_service_flutter/config/config.dart';
import 'package:book_service_flutter/home/class/post.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExchangeRequest extends StatefulWidget {
  final Post post;

  const ExchangeRequest({super.key, required this.post});

  @override
  State<ExchangeRequest> createState() => _ExchangeRequestState();
}

class _ExchangeRequestState extends State<ExchangeRequest> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final contentController = TextEditingController();

  List<dynamic> userPosts = []; // 사용자가 작성한 게시글 리스트
  int? selectedPostId; // 선택한 게시글의 ID

  @override
  void initState() {
    super.initState();
    _fetchUserPosts(); // 초기화 시 사용자 게시글 로드
  }

  Future<void> _fetchUserPosts() async {
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
        setState(() {
          userPosts = jsonDecode(utf8.decode(response.bodyBytes)); // 응답을 디코딩하여 게시글 리스트로 저장
        });
      } else {
        // 오류 처리
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('게시글을 불러오지 못했습니다.')),
        );
      }
    } catch (e) {
      // 네트워크 또는 기타 오류 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류 발생: $e')),
      );
    }
  }

  // 게시글 post와 교환할 책의 post 두개를 넘겨주고 title 넘겨주면 됨.
  Future<void> _submitExchangeRequest() async {
    if (_formKey.currentState!.validate()) {
      if (selectedPostId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('교환할 책을 선택해주세요.')),
        );
        return;
      }

      final url = Uri.parse('${Config.baseUrl}/api/reply/register');
      final body = jsonEncode({
        'post_id':widget.post.id,
        'title': titleController.text,
        'selected_post_id': selectedPostId,
      });

      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'authorization-token': Config.accessToken,
          },
          body: body,
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('교환 요청이 성공적으로 제출되었습니다.')),
          );
          Navigator.pop(context); // 제출 후 페이지 닫기
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('교환 요청 제출에 실패했습니다.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류 발생: $e')),
        );
      }
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
            icon: Icon(Icons.close)),
        title: Text('내 책 팔기'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(
                height: 8,
              ),
              Text('제목'),
              SizedBox(
                height: 8,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "제목을 입력해주세요.",
                          // hintText: "제목을 입력하세요."
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "필수 입력 항목입니다.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      const Text('내 게시글 목록'),
                      const SizedBox(height: 8),
                      userPosts.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                        shrinkWrap: true, // ListView가 다른 스크롤뷰 내에서 사용될 때
                        itemCount: userPosts.length,
                        itemBuilder: (context, index) {
                          final post = userPosts[index];
                          return ListTile(
                            leading: Radio<int>(
                              value: post['id'], // 게시글 ID를 value로 설정
                              groupValue: selectedPostId,
                              onChanged: (int? value) {
                                setState(() {
                                  selectedPostId = value;
                                });
                              },
                            ),
                            title: Text(post['title']),
                            subtitle: Text("${post['price']} 원"),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: (){
                          _submitExchangeRequest();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF53787E),
                            minimumSize: Size(double.infinity, 48)),
                        child: const Text(
                          "게시하기",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

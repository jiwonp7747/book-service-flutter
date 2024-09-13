
import 'package:book_service_flutter/config/config.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SellBookScreen extends StatefulWidget {
  const SellBookScreen({super.key});

  @override
  State<SellBookScreen> createState() => _SellBookScreenState();
}

class _SellBookScreenState extends State<SellBookScreen> {
  //File? image;
  final ImagePicker picker=ImagePicker();
  List<XFile?> _images = List<XFile?>.filled(3, null);

  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final contentController = TextEditingController();

  Future<void> registerPost() async { // post 게시하기
    if (_formKey.currentState!.validate()) {
      final String title = titleController.text;
      final String price = priceController.text;
      final String content = contentController.text;

      try {
       var uri=Uri.parse('${Config.baseUrl}/api/post');
       var request=http.MultipartRequest('Post', uri);

       // 요청 헤더 추가
       request.headers.addAll({
         'Content-Type': 'multipart/form-data',
         'authorization-token': Config.accessToken,
         //'Authorization'
       });

       // 요청 이미지 추가
       for (var image in _images) {
         if (image != null) {
           request.files.add(await http.MultipartFile.fromPath('files', image.path));
           print(image.path);
         }
       }

       // 텍스트 필드 추가
       request.fields['title']=title;
       request.fields['price']=price;
       request.fields['content']=content;
       // request.fields['userId']="1"; //TODO 실제 userId로 변경 필요

       // 요청 전송
       var response=await request.send();

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('책이 성공적으로 등록되었습니다.')),
          );
          Navigator.pop(context, true);
        } else {
          // 오류 처리
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('책 등록에 실패했습니다.')),
          );
        }
      } catch (e) {
        // 네트워크 또는 기타 오류 처리
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류 발생: $e')),
        );
      }
    }
  }

  // 이미지 선택 기능(모바일)
  Future<void> pickImage(int index) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        // _images.add(File(pickedFile.path));
        _images[index] = pickedFile;
      });
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
              GestureDetector(
                onTap: ()=>pickImage(0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _images[0]==null ? const Column(
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 50,
                        color: Colors.grey,
                      ),
                      Text('0/10'),
                    ],
                  ) : Image.file( // image 가 null이 아니면
                    File(_images[0]!.path),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

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
                      SizedBox(
                        height: 24,
                      ),
                      Text("가격 입력"),
                      TextFormField(
                        controller: priceController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "가격을 입력해주세요",
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "필수 입력 항목입니다.";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text("자세한 설명"),
                      TextFormField(
                        controller: contentController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "자세한 내용을 적어주세요",
                        ),
                        maxLength: 255,
                        maxLines: 8,
                        keyboardType: TextInputType.multiline,
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
                      ElevatedButton(
                        onPressed: registerPost,
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

import 'package:book_service_flutter/config/config.dart';
import 'package:book_service_flutter/login/register_success.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordValid = false;
  bool _isPasswordMatched = false;

  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> registerPost() async { // post 게시하기
    if (_formKey.currentState!.validate()) {
      final String email = _emailController.text;
      final String password = _passwordController.text;

      try {
        var uri=Uri.parse('${Config.baseUrl}/api/user');
        // JSON 데이터 준비
        var body = jsonEncode({
          'email': email,
          'password': password,
          'nickname': "임시닉네임",
          'address': "임시주소"
        });

        // POST 요청 수행
        var response = await http.post(
          uri,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('책이 성공적으로 등록되었습니다.')),
          );
          Navigator.push(context,
              MaterialPageRoute(builder: (context)=>RegisterSuccess())
          );
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

  void _validatePassword(String value) { //
    setState(() {
      _isPasswordValid = value.length >= 8 &&
          RegExp(r'[0-9]').hasMatch(value) &&
          RegExp(r'[A-Za-z]').hasMatch(value);
    });
  }

  void _checkPasswordMatch(String value) { // 비밀번호와 비밀번호 확인이 동일한지
    setState(() {
      _isPasswordMatched = value == _passwordController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    '회원님만의\n계정을 만들어주세요.',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text('아이디'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: '아이디를 입력해주세요',
                      filled: true,
                      fillColor: Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('비밀번호'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    onChanged: _validatePassword,
                    decoration: const InputDecoration(
                      hintText: '비밀번호를 입력해주세요',
                      filled: true,
                      fillColor: Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      suffixIcon: Icon(Icons.visibility_off),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        _isPasswordValid ? Icons.check_circle : Icons.cancel,
                        color: _isPasswordValid ? Colors.green : Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      const Text('8자리 이상'),
                      const SizedBox(width: 10),
                      Icon(
                        _isPasswordValid ? Icons.check_circle : Icons.cancel,
                        color: _isPasswordValid ? Colors.green : Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      const Text('숫자 포함'),
                      const SizedBox(width: 10),
                      Icon(
                        _isPasswordValid ? Icons.check_circle : Icons.cancel,
                        color: _isPasswordValid ? Colors.green : Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      const Text('영문 포함'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('비밀번호 확인'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    onChanged: _checkPasswordMatch,
                    decoration: const InputDecoration(
                      hintText: '비밀번호를 입력해주세요',
                      filled: true,
                      fillColor: Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      suffixIcon: Icon(Icons.visibility_off),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (!_isPasswordMatched && _confirmPasswordController.text.isNotEmpty)
                    const Row(
                      children: const [
                        Icon(
                          Icons.cancel,
                          color: Colors.red,
                          size: 16,
                        ),
                        SizedBox(width: 5),
                        Text(
                          '비밀번호 불일치',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate() &&
                  _isPasswordValid &&
                  _isPasswordMatched) {
                // 가입하기 버튼 클릭 시 처리 로직
                registerPost();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF53787E),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              '가입하기',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}



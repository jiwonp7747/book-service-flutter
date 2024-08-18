import 'package:flutter/material.dart';
import 'package:book_service_flutter/login/register_user.dart';

class LoginService extends StatefulWidget {
  const LoginService({super.key});

  @override
  _LoginServiceState createState() => _LoginServiceState();
}

class _LoginServiceState extends State<LoginService> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false; // 비밀번호 가시성 상태

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 130),
                const Text(
                  '반갑습니다!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '로그인',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF53787E),
                        ),
                      ),
                      TextSpan(
                        text: '을 해주세요.',
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: '아이디',
                    hintText: '아이디를 입력해주세요',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    filled: true,
                    fillColor: Color(0xFFF5F5F5),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '아이디를 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  obscureText: !_isPasswordVisible, // 비밀번호 가시성 상태에 따라 텍스트 가림 여부 설정
                  decoration: InputDecoration(
                    labelText: '비밀번호',
                    hintText: '비밀번호를 입력해주세요',
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 300),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("계정이 없으신가요?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterUser()),
                        );
                      },
                      child: const Text(
                        '회원가입',
                        style: TextStyle(
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 260),
              ],
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
              if (_formKey.currentState!.validate()) {
                // 로그인 버튼 클릭 이벤트 처리
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
              '로그인하기',
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




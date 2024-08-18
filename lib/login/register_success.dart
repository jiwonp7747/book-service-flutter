import 'package:flutter/material.dart';
import 'package:book_service_flutter/login/login_service.dart';

class RegisterSuccess extends StatefulWidget {
  const RegisterSuccess({super.key});

  @override
  State<RegisterSuccess> createState() => _RegisterSuccessState();
}

class _RegisterSuccessState extends State<RegisterSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SafeArea(
        child: Center(
          child: Column(
            children: [
              const Spacer(),
              CircleAvatar(
                radius: 40,
                backgroundColor: const Color(0xFF53787E),
                child: const Icon(
                  Icons.check,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '가입완료!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginService()),
              );
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


import 'package:flutter/material.dart';
import 'package:frontend/features/auth/widgets/auth_text_field.dart';
import 'package:frontend/features/auth/widgets/auth_button.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 56),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Login",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            AuthTextField(
              label: "Email",
              hint: "example@email.com",
              controller: email,
            ),

            AuthTextField(
              label: "Password",
              hint: "Your Password",
              controller: password,
              obscure: true,
            ),

            const SizedBox(height: 12),

            AuthButton(
              text: "Continue",
              onPressed: () {
                // 로그인 API 연동 예정
              },
            ),

            const SizedBox(height: 12),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignupScreen()),
                );
              },
              child: const Text("회원가입하기"),
            ),
          ],
        ),
      ),
    );
  }
}

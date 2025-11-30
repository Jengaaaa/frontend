import 'package:flutter/material.dart';
import 'package:frontend/common_widgets/primary_button.dart';
import 'package:frontend/features/auth/widgets/auth_text_field.dart';
import 'package:frontend/features/home/home_screen.dart';
import 'signup_screen.dart';
import 'auth_api.dart';

class LoginScreen extends StatefulWidget {
  final String? job; // 'police' 또는 'firefighter'

  const LoginScreen({super.key, this.job});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();

  bool _loggingIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Login",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              AuthTextField(
                label: "Email",
                hint: "hola@soytian.tech",
                controller: email,
                borderColor: const Color(0xFFB5D1DA),
              ),
              AuthTextField(
                label: "Password",
                hint: "Placeholder",
                controller: password,
                obscure: true,
                borderColor: const Color(0xFFB5D1DA),
              ),
              const SizedBox(height: 8),
              PrimaryButton(
                text: "완료",
                backgroundColor: Colors.black,
                disabled: _loggingIn,
                onPressed: () async {
                  setState(() => _loggingIn = true);
                  try {
                    final token = await AuthApi.login(
                      email: email.text.trim(),
                      password: password.text,
                    );

                    if (!mounted) return;
                    // TODO: 토큰을 secure storage 등에 저장
                    debugPrint('로그인 토큰: $token');

                    // 선택된 직군에 따라 홈 화면으로 이동
                    final job = widget.job ?? 'police';
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HomeScreen(job: job),
                      ),
                    );
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(e.toString())));
                  } finally {
                    if (mounted) {
                      setState(() => _loggingIn = false);
                    }
                  }
                },
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignupScreen()),
                    );
                  },
                  child: const Text("회원가입하기"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

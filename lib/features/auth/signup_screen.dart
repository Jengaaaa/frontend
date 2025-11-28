import 'package:flutter/material.dart';
import 'package:frontend/features/auth/widgets/auth_text_field.dart';
import 'package:frontend/features/auth/widgets/auth_button.dart';
import 'signup_success_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();

  String? emailError;
  String? passwordError;
  String? confirmError;

  bool validate() {
    bool ok = true;

    // 이메일 검증
    if (!email.text.contains("@")) {
      emailError = "올바른 이메일이 아닙니다.";
      ok = false;
    } else {
      emailError = null;
    }

    // 비밀번호 검증
    if (password.text.length < 6) {
      passwordError = "6자 이상 입력해주세요.";
      ok = false;
    } else {
      passwordError = null;
    }

    // 비밀번호 확인 검증
    if (password.text != confirm.text) {
      confirmError = "비밀번호가 일치하지 않습니다.";
      ok = false;
    } else {
      confirmError = null;
    }

    setState(() {});
    return ok;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("회원가입"),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            AuthTextField(
              label: "이메일",
              hint: "example@email.com",
              controller: email,
              errorText: emailError,
            ),
            AuthTextField(
              label: "비밀번호",
              hint: "6자 이상",
              obscure: true,
              controller: password,
              errorText: passwordError,
            ),
            AuthTextField(
              label: "비밀번호 확인",
              hint: "다시 입력",
              obscure: true,
              controller: confirm,
              errorText: confirmError,
            ),

            const SizedBox(height: 12),

            AuthButton(
              text: "완료",
              onPressed: () {
                if (validate()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupSuccessScreen()),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

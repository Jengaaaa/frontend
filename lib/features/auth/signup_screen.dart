import 'package:flutter/material.dart';
import 'package:frontend/common_widgets/primary_button.dart';
import 'package:frontend/features/auth/widgets/auth_text_field.dart';
import 'package:frontend/features/survey/survey_job_screen.dart';
import 'auth_api.dart';

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

  bool _submitting = false;

  String? emailError;
  String? passwordError;
  String? confirmError;

  // stroke / button 색상
  Color strokeColor = const Color(0xFFCCCCCC);
  Color buttonColor = Colors.black;

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

    // 색상 업데이트
    if (ok) {
      strokeColor = const Color(0xFFABC7D0);
      buttonColor = const Color(0xFFABC7D0);
    } else {
      strokeColor = const Color(0xFFFF5558);
      buttonColor = const Color(0xFFFF5558);
    }

    setState(() {});
    return ok;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/logo2.png',
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                  const Spacer(),
                  const Text(
                    "회원가입",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    AuthTextField(
                      label: "이름",
                      hint: "이름",
                      controller: name,
                      borderColor: strokeColor,
                      errorBorderColor: strokeColor,
                    ),
                    AuthTextField(
                      label: "이메일",
                      hint: "이메일",
                      controller: email,
                      errorText: emailError,
                      borderColor: strokeColor,
                      errorBorderColor: strokeColor,
                    ),
                    AuthTextField(
                      label: "비밀번호",
                      hint: "비밀번호",
                      obscure: true,
                      controller: password,
                      errorText: passwordError,
                      borderColor: strokeColor,
                      errorBorderColor: strokeColor,
                    ),
                    AuthTextField(
                      label: "비밀번호 확인",
                      hint: "비밀번호 확인",
                      obscure: true,
                      controller: confirm,
                      errorText: confirmError,
                      borderColor: strokeColor,
                      errorBorderColor: strokeColor,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: PrimaryButton(
                text: "완료",
                backgroundColor: buttonColor,
                disabled: _submitting,
                onPressed: () async {
                  if (!validate()) return;

                  setState(() => _submitting = true);
                  try {
                    await AuthApi.signUp(
                      email: email.text.trim(),
                      password: password.text,
                      passwordCheck: confirm.text,
                    );

                    if (!mounted) return;
                    // 회원가입 성공 후 직군 선택 화면으로 이동하면서 이름 전달
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            SurveyJobScreen(userName: name.text.trim()),
                      ),
                    );
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(e.toString())));
                  } finally {
                    if (mounted) {
                      setState(() => _submitting = false);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

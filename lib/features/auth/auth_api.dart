import 'dart:convert';

import 'package:http/http.dart' as http;

/// 백엔드 Spring 서버와 통신하는 Auth API 헬퍼
class AuthApi {
  /// 실제 서버 주소에 맞게 변경하세요.
  /// - 안드로이드 에뮬레이터: http://10.0.2.2:8080
  /// - iOS 시뮬레이터 / 웹: http://localhost:8080 또는 서버 IP
  static const String _baseUrl = 'http://10.0.2.2:8080';
  // static const String _baseUrl = 'http://localhost:8080';

  /// 회원가입
  /// POST /api/user/signup
  /// Body: { "email": "", "password": "", "passwordCheck": "" }
  static Future<void> signUp({
    required String email,
    required String password,
    required String passwordCheck,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/user/signup');

    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'passwordCheck': passwordCheck,
      }),
    );

    if (resp.statusCode != 200) {
      // 백엔드에서 RuntimeException 메시지를 body로 내려줄 수 있으므로 그대로 노출
      throw Exception('회원가입에 실패했습니다 (${resp.statusCode}) : ${resp.body}');
    }
    // 성공 시 백엔드는 "회원가입 완료!" 문자열을 반환하므로 별도 파싱은 하지 않음
  }

  /// 로그인
  /// POST /api/user/login
  /// Body: { "email": "", "password": "" }
  /// Response: { "token": "TOKEN_xxx" }
  static Future<String> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/user/login');

    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (resp.statusCode != 200) {
      throw Exception('로그인에 실패했습니다 (${resp.statusCode}) : ${resp.body}');
    }

    final Map<String, dynamic> data = jsonDecode(resp.body);
    final token = data['token'];
    if (token is! String) {
      throw Exception('로그인 응답에 token이 없습니다.');
    }
    return token;
  }
}

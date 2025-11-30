import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// 회원가입 1단계 응답 DTO (백엔드 SignUpResponse 매핑)
class SignUpResult {
  final int userId;
  final String message;

  SignUpResult({required this.userId, required this.message});
}

/// 백엔드 Spring 서버와 통신하는 Auth API 헬퍼
class AuthApi {
  /// 실제 서버 주소에 맞게 변경하세요.
  /// - 안드로이드 에뮬레이터: http://10.0.2.2:8080
  /// - iOS 시뮬레이터 / 웹: http://localhost:8080 또는 서버 IP
  // static const String _baseUrl = 'http://10.0.2.2:8080';
  // static const String _baseUrl = 'http://localhost:8080';
  static const String _baseUrl = 'http://192.168.30.5:8080';

  /// 회원가입 1단계
  /// POST /api/user/signup
  /// Body: { "email": "", "name": "", "password": "", "passwordCheck": "" }
  /// Response: { "userId": 1, "message": "..." }
  static Future<SignUpResult> signUp({
    required String name,
    required String email,
    required String password,
    required String passwordCheck,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/user/signup');

    debugPrint('[AuthApi.signUp] 요청: $uri name=$name, email=$email');

    http.Response resp;
    try {
      resp = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
              'passwordCheck': passwordCheck,
            }),
          )
          .timeout(const Duration(seconds: 5));
    } on TimeoutException catch (e) {
      debugPrint('[AuthApi.signUp] 타임아웃: $e');
      throw Exception('회원가입 요청이 시간 초과되었습니다. 서버가 실행 중인지 확인해주세요.');
    } catch (e) {
      debugPrint('[AuthApi.signUp] 예외 발생: $e');
      rethrow;
    }

    debugPrint(
      '[AuthApi.signUp] 응답 코드: ${resp.statusCode}, body: ${resp.body}',
    );

    if (resp.statusCode != 200) {
      // 백엔드에서 RuntimeException 메시지를 body로 내려줄 수 있으므로 그대로 노출
      throw Exception('회원가입에 실패했습니다 (${resp.statusCode}) : ${resp.body}');
    }

    final Map<String, dynamic> data = jsonDecode(resp.body);
    final dynamic idVal = data['userId'];
    final dynamic msgVal = data['message'];

    if (idVal == null || msgVal == null) {
      throw Exception('회원가입 응답에 userId 또는 message가 없습니다.');
    }

    final int userId;
    if (idVal is int) {
      userId = idVal;
    } else if (idVal is num) {
      userId = idVal.toInt();
    } else {
      throw Exception('회원가입 응답의 userId 형식이 올바르지 않습니다.');
    }

    return SignUpResult(userId: userId, message: msgVal.toString());
  }

  /// 회원가입 2단계 - 직군 선택
  /// POST /api/user/signup/job
  /// Body: { "userId": 1, "job": "police" | "firefighter" }
  static Future<void> selectJob({
    required int userId,
    required String job,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/user/signup/job');

    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'job': job}),
    );

    if (resp.statusCode != 200) {
      throw Exception('직군 선택에 실패했습니다 (${resp.statusCode}) : ${resp.body}');
    }
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

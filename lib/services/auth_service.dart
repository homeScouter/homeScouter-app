import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

// 사용자 정의 예외 클래스들
class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

class EmailAlreadyInUseException extends AuthException {
  EmailAlreadyInUseException(String message) : super(message);
}

class InvalidEmailException extends AuthException {
  InvalidEmailException(String message) : super(message);
}

class WeakPasswordException extends AuthException {
  WeakPasswordException(String message) : super(message);
}

class NetworkException extends AuthException {
  NetworkException(String message) : super(message);
}

class AuthService {
  final String _baseUrl = 'http://localhost:8000/api';

  Future<UserModel> signUp({
    required String name,
    required String id, // Django 백엔드에서 'id'로 받아서 email로 사용
    required String password,
    required String phone,
    required String tapoCode,
  }) async {
    final url = Uri.parse('$_baseUrl/signup/'); // 회원가입 API 엔드포인트

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'id': id, // 백엔드에서는 이걸 email로 사용합니다.
          'password': password,
          'phone': phone,
          'tapoCode': tapoCode, // 백엔드 필드명과 일치
        }),
      );

      if (response.statusCode == 201) {
        // 성공 (HTTP 201 Created)
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        // 백엔드에서 반환하는 UID, email, name 등을 포함하는 JSON 데이터를 UserModel로 변환하여 반환
        return UserModel.fromJson(
          responseBody,
        ); // 백엔드 응답이 UserModel 형식과 일치한다고 가정
      } else {
        // 백엔드에서 에러 응답을 받았을 경우
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        final String errorMessage =
            errorBody['message'] ?? '알 수 없는 오류가 발생했습니다.';

        // 백엔드의 에러 메시지에 따라 특정 예외 발생
        if (response.statusCode == 409 &&
            errorMessage.contains('이미 사용 중인 이메일')) {
          throw EmailAlreadyInUseException(errorMessage);
        } else if (response.statusCode == 400 &&
            errorMessage.contains('유효하지 않은 이메일')) {
          throw InvalidEmailException(errorMessage);
        } else if (response.statusCode == 400 &&
            errorMessage.contains('비밀번호가 너무 약합니다')) {
          throw WeakPasswordException(errorMessage);
        } else {
          throw AuthException(errorMessage); // 일반적인 인증 오류
        }
      }
    } on http.ClientException catch (e) {
      // 네트워크 연결 문제 또는 서버 응답 없음
      throw NetworkException('네트워크 연결에 문제가 있습니다: ${e.message}');
    } catch (e) {
      // 그 외 알 수 없는 오류
      throw AuthException('회원가입 중 예상치 못한 오류 발생: $e');
    }
  }
}

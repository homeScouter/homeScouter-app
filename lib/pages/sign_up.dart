// lib/pages/SignUp.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // ⭐️ 추가: FCM 토큰을 얻기 위해 필요

import 'package:homescouter_app/pages/Login.dart';
import '../utils/constant_colors.dart';
import '../widgets/app_button.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart'; // UserModel 임포트

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // 입력값 컨트롤러
  final _nameController = TextEditingController();
  final _idController = TextEditingController(); // 백엔드에서는 email로 사용됨
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _tapoController = TextEditingController();

  bool _hidePassword = true;
  bool _isLoading = false; // 로딩 상태를 관리할 변수

  final _formKey = GlobalKey<FormState>(); // 폼 유효성 검사를 위한 GlobalKey

  // AuthService 인스턴스 생성
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _tapoController.dispose();
    super.dispose();
  }

  // 오류 다이얼로그 표시 도우미 메서드
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('확인'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  // 회원가입 처리 메서드
  Future<void> _handleSignUp() async {
    // 폼 유효성 검사
    if (_formKey.currentState?.validate() == true) {
      setState(() {
        _isLoading = true; // 로딩 시작
      });

      // ⭐️ 중요: FCM 토큰 가져오기 및 유효성 검사
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      print('회원가입 시도: 가져온 FCM 토큰: "$fcmToken"'); // 디버깅을 위한 로그

      // FCM 토큰이 null이거나 빈 문자열인지 확인
      if (fcmToken == null || fcmToken.isEmpty) {
        _showErrorDialog(
          '알림 설정 오류',
          '기기 알림 설정을 초기화할 수 없습니다. 잠시 후 다시 시도하거나, 앱을 재설치 해주세요.',
        );
        setState(() {
          _isLoading = false; // 로딩 종료
        });
        print('FCM Token이 null이거나 빈 문자열이어서 회원가입을 중단합니다.');
        return; // 토큰이 유효하지 않으면 회원가입 중단
      }

      try {
        final UserModel newUser = await _authService.signUp(
          name: _nameController.text.trim(),
          id: _idController.text.trim(),
          password: _passwordController.text.trim(),
          phone: _phoneController.text.trim(),
          tapoCode: _tapoController.text.trim(),
          fcmToken: fcmToken, // ⭐️ FCM 토큰을 AuthService.signUp에 전달
        );

        // 성공 메시지 및 로그인 페이지로 이동
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${newUser.name}님, 회원가입이 완료되었습니다!"),
            backgroundColor: Constants.primaryColor,
            duration: const Duration(seconds: 3),
          ),
        );
        // 회원가입 성공 후 로그인 페이지로 이동 (이전 페이지 스택 제거)
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
      } on AuthException catch (e) {
        // 정의된 인증 예외 처리 (백엔드에서 발생한 특정 오류 메시지)
        _showErrorDialog("회원가입 실패", "회원가입에 실패했습니다: ${e.message}");
        print("회원가입 오류: ${e.message}");
      } catch (e) {
        // 그 외 알 수 없는 오류
        _showErrorDialog(
          "알 수 없는 오류",
          "서버와의 통신 중 알 수 없는 오류가 발생했습니다. 잠시 후 다시 시도해주세요.",
        );
        print("예상치 못한 오류: $e");
      } finally {
        setState(() {
          _isLoading = false; // 로딩 종료
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_add, color: Constants.primaryColor, size: 52),
              SizedBox(height: 14),
              Container(
                width: size.width < 400 ? double.infinity : 400,
                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 38),
                decoration: BoxDecoration(
                  color: Constants.surfaceColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 14,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "회원가입",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Constants.primaryColor,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      // 이름
                      TextFormField(
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: "이름",
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: Constants.accentColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Constants.backgroundColor,
                        ),
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                            ? "이름을 입력하세요."
                            : null,
                      ),
                      SizedBox(height: 13),
                      // 아이디 (이메일로 사용)
                      TextFormField(
                        controller: _idController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress, // 이메일 키보드 타입
                        decoration: InputDecoration(
                          labelText: "아이디 (이메일)", // 사용자에게 이메일임을 명시
                          prefixIcon: Icon(
                            Icons.alternate_email,
                            color: Constants.accentColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Constants.backgroundColor,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "아이디(이메일)를 입력하세요.";
                          }
                          // 간단한 이메일 유효성 검사 (더 강력한 정규식 사용 가능)
                          if (!value.contains('@') || !value.contains('.')) {
                            return "유효한 이메일 형식이 아닙니다.";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 13),
                      // 비밀번호
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _hidePassword,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: "비밀번호",
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Constants.accentColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Constants.backgroundColor,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Constants.textSecondary,
                            ),
                            onPressed: () =>
                                setState(() => _hidePassword = !_hidePassword),
                          ),
                        ),
                        validator: (value) =>
                            (value == null ||
                                value.trim().length < 6) // Firebase 최소 6자 권장
                            ? "6글자 이상 비밀번호를 입력하세요."
                            : null,
                      ),
                      SizedBox(height: 13),
                      // 전화번호
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: "전화번호",
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Constants.accentColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Constants.backgroundColor,
                        ),
                        validator: (value) =>
                            (value == null ||
                                value.trim().length < 10) // 실제 전화번호 길이 고려
                            ? "유효한 전화번호를 입력하세요."
                            : null,
                      ),
                      SizedBox(height: 13),
                      // TAPO 기기코드
                      TextFormField(
                        controller: _tapoController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "TAPO 기기 코드",
                          prefixIcon: Icon(
                            Icons.qr_code,
                            color: Constants.accentColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Constants.backgroundColor,
                        ),
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                            ? "기기 코드를 입력하세요."
                            : null,
                      ),
                      SizedBox(height: 27),
                      AppButton(
                        text: _isLoading
                            ? "회원가입 중..."
                            : "회원가입 완료", // 로딩 상태에 따라 텍스트 변경
                        type: ButtonType.PRIMARY,
                        onPressed: _isLoading
                            ? () {} // ⭐️ 로딩 중일 때는 빈 함수 전달로 비활성화
                            : () {
                                _handleSignUp(); // _handleSignUp()를 호출합니다.
                              },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 18),
              Text(
                "이미 계정이 있으신가요?",
                style: GoogleFonts.notoSansKr(
                  fontSize: 13,
                  color: Constants.textSecondary,
                ),
              ),
              TextButton(
                onPressed: () {
                  // 로그인 페이지로 이동 (이전 페이지 스택 제거)
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                child: Text(
                  "로그인하러 가기",
                  style: GoogleFonts.notoSansKr(
                    color: Constants.accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homescouter_app/pages/Login.dart';
import '../utils/constant_colors.dart';
import '../widgets/app_button.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // 입력값 컨트롤러
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _tapoController = TextEditingController();

  bool _hidePassword = true;

  // 예시용 폼 validation (실 서비스 시 보완 필요)
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _tapoController.dispose();
    super.dispose();
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
                            ? "이름을 입력하세요"
                            : null,
                      ),
                      SizedBox(height: 13),
                      // 아이디
                      TextFormField(
                        controller: _idController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: "아이디",
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
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                            ? "아이디를 입력하세요"
                            : null,
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
                            (value == null || value.trim().length < 4)
                            ? "4글자 이상 비밀번호"
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
                            (value == null || value.trim().length < 9)
                            ? "전화번호를 입력하세요"
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
                            ? "기기 코드를 입력하세요"
                            : null,
                      ),
                      SizedBox(height: 27),
                      AppButton(
                        text: "회원가입 완료",
                        type: ButtonType.PRIMARY,
                        onPressed: () {
                          if (_formKey.currentState?.validate() == true) {
                            // 회원가입 처리 (백엔드 연동 등)
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("회원가입이 완료되었습니다!"),
                                backgroundColor: Constants.primaryColor,
                              ),
                            );
                          }
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

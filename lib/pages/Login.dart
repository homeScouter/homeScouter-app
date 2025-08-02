import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homescouter_app/pages/sign_up.dart';
import '../utils/constant_colors.dart';
import '../widgets/app_button.dart';
import 'package:homescouter_app/pages/Home.dart';

class Login extends StatelessWidget {
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
              Icon(Icons.security, color: Constants.primaryColor, size: 56),
              SizedBox(height: 18.0),
              Container(
                width: size.width < 400 ? double.infinity : 400,
                padding: EdgeInsets.symmetric(horizontal: 28.0, vertical: 40.0),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Home Scouter",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Constants.primaryColor,
                        letterSpacing: 1.2,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      "당신의 집을 안전하게 지켜드립니다",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSansKr(
                        color: Constants.textSecondary,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 18.0),
                    Divider(
                      height: 1,
                      color: Constants.backgroundColor,
                      thickness: 1.0,
                    ),
                    SizedBox(height: 18.0),
                    Text(
                      "카메라로 위험상태를 탐지하고\n긴급 상황엔 신고까지!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSansKr(
                        color: Constants.textPrimary.withOpacity(0.9),
                        fontSize: 14.5,
                        height: 1.45,
                      ),
                    ),
                    SizedBox(height: 34.0),
                    AppButton(
                      text: "로그인",
                      type: ButtonType.PRIMARY,
                      // PRIMARY가 accentColor로 적용, WHITE 글씨
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      },
                    ),
                    SizedBox(height: 13.0),
                    AppButton(
                      text: "회원가입",
                      type: ButtonType.PLAIN, // PLain은 일반 테두리형(또는 흰배경)
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => SignUp()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.0),
              Text(
                "© 2025 Home Scouter",
                style: GoogleFonts.notoSansKr(
                  fontSize: 12,
                  color: Constants.textSecondary,
                  letterSpacing: 0.2,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

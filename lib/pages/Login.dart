import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/app_button.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.primaryColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              decoration: BoxDecoration(
                color: Constants.scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15.0),
                  topLeft: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.0),
                  Text(
                    "홈 스카우터 당신의 집을 지켜드림(아마도)",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(19, 22, 33, 1),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "카메라로 당신의 위험상태를 확인하며 신고해드림",
                    style: TextStyle(
                      color: Color.fromRGBO(74, 77, 84, 1),
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 40.0),
                  AppButton(
                    text: "로그인",
                    type: ButtonType.PLAIN,
                    onPressed: () {},
                  ),
                  SizedBox(height: 15.0),
                  AppButton(
                    text: "회원가입",
                    type: ButtonType.PRIMARY,
                    onPressed: () {
                      // 회원가입 페이지로 이동하는 코드
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

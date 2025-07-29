import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homescouter_app/pages/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 화면 크기 설정
    return ScreenUtilInit(
      designSize: Size(375, 812), // 화면 기준 크기 (디자인 기준)
      builder: (context, child) {
        return MaterialApp(debugShowCheckedModeBanner: false, home: Home());
      },
    );
  }
}

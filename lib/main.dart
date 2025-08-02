// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homescouter_app/pages/home.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// ⭐️ NotificationService 임포트
import 'package:homescouter_app/services/notification_service.dart';

// ⭐️ 수정됨: 백그라운드 메시지 처리를 위한 최상위 함수
// 이 함수는 NotificationService 파일에 정의된 public 함수인 firebaseMessagingBackgroundHandler를 사용합니다.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) =>
    firebaseMessagingBackgroundHandler(message); // _ (밑줄) 제거하고 직접 함수 이름 사용!

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ⭐️ 백그라운드 메시지 핸들러 등록
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // 앱의 초기화 상태를 추적합니다.
  bool _isFirebaseAndFCMInitialized = false;

  // NotificationService 인스턴스
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _initializeFCMService(); // FCM 서비스 초기화 함수 호출
  }

  // ⭐️ NotificationService를 통해 FCM 관련 설정을 하는 함수
  Future<void> _initializeFCMService() async {
    await _notificationService.initialize(); // NotificationService의 초기화 함수 호출

    setState(() {
      _isFirebaseAndFCMInitialized = true; // 모든 FCM 설정이 완료되었음을 표시
    });
  }

  @override
  Widget build(BuildContext context) {
    // _isFirebaseAndFCMInitialized가 false면 로딩 스피너를 보여줄 수 있습니다.
    if (!_isFirebaseAndFCMInitialized) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(), // Firebase & FCM 초기화 중...
          ),
        ),
      );
    }

    // 초기화가 완료되면 정상적인 앱을 보여줍니다.
    return ScreenUtilInit(
      designSize: Size(375, 812), // 화면 기준 크기 (디자인 기준)
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Home(), // 여러분의 Home 페이지
          // ⭐️ NavigatorKey를 MaterialApp에 연결하여 NotificationService가 UI를 제어할 수 있도록 합니다.
          navigatorKey: NotificationService.navigatorKey,
        );
      },
    );
  }
}

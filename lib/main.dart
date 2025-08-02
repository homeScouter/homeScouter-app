import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homescouter_app/pages/home.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// ⭐️ 중요: 백그라운드 메시지 처리를 위한 최상위 함수
// 이 함수는 앱이 백그라운드에 있거나 종료된 상태일 때 FCM 메시지를 받으면 호출됩니다.
// @pragma('vm:entry-point') 어노테이션은 Dart 컴파일러에게 이 함수를 별도의 실행 진입점으로 유지하라고 알려줍니다.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // 백그라운드 메시지를 처리하기 전에 Firebase를 다시 초기화해야 할 수 있습니다.
  // 이 부분은 앱의 복잡도에 따라 필요할 수도 있고 아닐 수도 있습니다.
  // 처음에는 주석 처리해두시고, 문제가 생기면 주석을 해제해 보세요.
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  print("🎉 [Background] FCM Message Received: ${message.messageId}");
  print("🚀 [Background] Notification Title: ${message.notification?.title}");
  print("🚀 [Background] Notification Body: ${message.notification?.body}");
  print("💡 [Background] Data Payload: ${message.data}");
}

void main() async {
  // main 함수를 비동기(async)로 만듭니다.
  // Flutter 위젯 바인딩이 초기화될 때까지 기다립니다.
  // Firebase와 같은 네이티브 기능(플랫폼 채널)을 사용하기 위해 꼭 필요해요.
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 앱을 초기화합니다.
  // DefaultFirebaseOptions.currentPlatform은 여러분의 Firebase 프로젝트와 연결해주는 마법사 같은 역할이에요.
  // 이 파일(firebase_options.dart)은 'flutterfire configure' 명령어를 실행하면 자동으로 생성됩니다.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ⭐️ 백그라운드 메시지 핸들러 등록
  // 앱이 실행 중이지 않거나 백그라운드에 있을 때 메시지를 받으면 위에서 정의한 함수가 호출되도록 설정합니다.
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // StatelessWidget에서 StatefulWidget으로 변경!
  @override
  _MyAppState createState() => _MyAppState(); // 상태를 관리하는 State 클래스를 만듭니다.
}

class _MyAppState extends State<MyApp> {
  // 앱의 초기화 상태를 추적합니다.
  bool _firebaseInitialized = false;
  // FCM 토큰을 저장할 변수 (선택 사항이지만 테스트에 유용)
  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    _initializeFCM(); // FCM 초기화 함수를 호출합니다.
  }

  // ⭐️ FCM 관련 설정을 하는 비동기 함수
  Future<void> _initializeFCM() async {
    // 1. 알림 권한 요청 (iOS 및 웹에서는 필수)
    // 안드로이드 13(API 33) 이상에서도 런타임 권한 요청이 필요해요.
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(
          alert: true, // 알림 메시지 표시
          announcement: false, // 발표 알림 (시리와 같은 음성 비서 사용 시)
          badge: true, // 앱 아이콘의 뱃지
          carPlay: false, // CarPlay에서 알림 표시
          criticalAlert: false, // 중요한 알림 (방해 금지 모드 무시)
          provisional: false, // 임시 알림 (자동 부여되지만 소리/진동 없음)
          sound: true, // 알림 소리 재생
        );

    print('📢 User granted permission: ${settings.authorizationStatus}');

    // 2. FCM 토큰 얻기 및 확인
    // 이 토큰이 바로 특정 기기에 메시지를 보낼 때 사용하는 고유 ID입니다!
    String? token = await FirebaseMessaging.instance.getToken();
    setState(() {
      _fcmToken = token; // 토큰을 상태 변수에 저장
    });
    print('🔑 Your FCM Token: $_fcmToken'); // 토큰을 콘솔에 출력!

    // ⭐️ 팁: 이 토큰을 여러분의 데이터베이스 (예: Firestore)에 사용자 ID와 함께 저장하면,
    // 나중에 특정 사용자에게 알림을 보낼 때 유용하게 쓸 수 있습니다.

    // 토큰이 변경될 경우를 대비하여 리스너 설정
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print('🔄 FCM Token Refreshed: $newToken');
      setState(() {
        _fcmToken = newToken;
      });
      // 새 토큰을 서버나 데이터베이스에 업데이트하는 로직을 여기에 추가하세요.
    });

    // 3. 포그라운드 메시지 처리 (앱이 실행 중이고 화면에 보일 때)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("🎉 [Foreground] FCM Message Received: ${message.messageId}");
      print(
        "🚀 [Foreground] Notification Title: ${message.notification?.title}",
      );
      print("🚀 [Foreground] Notification Body: ${message.notification?.body}");
      print("💡 [Foreground] Data Payload: ${message.data}");

      // ⭐️ 중요: 앱이 포그라운드일 때는 OS가 자동으로 알림을 띄우지 않습니다.
      // 따라서 flutter_local_notifications와 같은 패키지를 사용하여
      // 직접 로컬 알림을 띄워줘야 사용자에게 알림이 보입니다.
      // 이 부분은 일단 생략하고, 나중에 필요할 때 추가하면 됩니다.
      // 예: MyLocalNotificationService.showNotification(message.notification);
    });

    // 4. 앱이 백그라운드에서 알림을 탭하여 열었을 때 처리
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
        "🎉 [Opened] App opened from background with message: ${message.messageId}",
      );
      print("💡 [Opened] Data Payload: ${message.data}");
      // 메시지 데이터에 따라 특정 화면으로 이동하거나 추가 로직을 수행할 수 있습니다.
    });

    // 5. 앱이 종료 상태에서 알림을 탭하여 열었을 때 처리
    // 이 함수는 앱이 완전히 종료된 상태에서 알림을 탭했을 때 한 번만 호출됩니다.
    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message != null) {
        print(
          "🎉 [Initial] App opened from terminated state with message: ${message.messageId}",
        );
        print("💡 [Initial] Data Payload: ${message.data}");
        // 여기서 메시지 데이터에 따라 초기 화면을 변경하거나 특정 작업을 수행할 수 있습니다.
      }
    });

    setState(() {
      _firebaseInitialized = true; // 모든 FCM 설정이 완료되었음을 표시
    });
  }

  @override
  Widget build(BuildContext context) {
    // _firebaseInitialized가 false면 로딩 스피너를 보여줄 수 있습니다.
    if (!_firebaseInitialized) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(), // Firebase 초기화 중...
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
        );
      },
    );
  }
}

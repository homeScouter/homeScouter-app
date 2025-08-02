// lib/services/notification_service.dart

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart'; // UI 관련 기능 (Dialog, SnackBar)을 위해 필요

// ⭐️ 수정됨: 백그라운드 메시지 처리를 위한 최상위(Top-level) 함수
// 이 함수는 'public'으로 변경되어 main.dart에서 접근 가능합니다.
// FirebaseMessaging.onBackgroundMessage()에 등록될 함수는 반드시 최상위 함수이거나 static 메서드여야 합니다.
// 이 함수는 앱이 백그라운드에 있거나 종료된 상태일 때 FCM 메시지를 받으면 호출됩니다.
// @pragma('vm:entry-point') 어노테이션은 Dart 컴파일러에게 이 함수를 별도의 실행 진입점으로 유지하라고 알려줍니다.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // _ (밑줄) 제거!
  // 백그라운드 메시지를 처리하기 전에 Firebase를 다시 초기화해야 할 수 있습니다.
  // 특히 앱이 완전히 종료된 상태에서 알림을 받아 이 함수가 처음 호출될 때는 필요할 수 있습니다.
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); // 필요시 주석 해제

  print(
    "🎉 [Background] FCM Message Received (via top-level handler): ${message.messageId}",
  );
  print("💡 [Background] Data Payload: ${message.data}");

  // NotificationService의 정적 메서드를 호출하여 실제 로직을 처리합니다.
  NotificationService.handleIncomingMessage(message, isBackground: true);
}

class NotificationService {
  // 싱글톤 패턴: 앱 전체에서 NotificationService의 단일 인스턴스만 사용하도록 합니다.
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // NavigatorKey를 사용하여 서비스 클래스 내에서 네비게이션 및 다이얼로그를 제어할 수 있도록 합니다.
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // FCM 초기화 및 리스너 설정을 담당하는 함수
  Future<void> initialize() async {
    // 1. 알림 권한 요청
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
    print(
      '📢 User granted notification permission: ${settings.authorizationStatus}',
    );

    // 2. FCM 토큰 얻기 및 확인
    String? token = await FirebaseMessaging.instance.getToken();
    print('🔑 Your FCM Token: $token');
    // ⭐️ 중요: 이 토큰을 여러분의 백엔드 또는 Firestore DB에 저장하여 특정 기기로 메시지를 보낼 때 활용하세요.

    // 3. 토큰 변경 감지 리스너
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print('🔄 FCM Token Refreshed: $newToken');
      // ⭐️ 중요: 새 토큰을 백엔드/DB에 업데이트하는 로직을 여기에 추가하세요.
    });

    // 4. 포그라운드 메시지 핸들러 등록
    FirebaseMessaging.onMessage.listen(
      (message) => handleIncomingMessage(message, isForeground: true),
    );

    // 5. 앱이 백그라운드/종료 상태에서 알림 탭하여 열었을 때 핸들러 등록
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) => handleIncomingMessage(message, isOpenedApp: true),
    );
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        handleIncomingMessage(message, isOpenedApp: true, isInitial: true);
      }
    });
  }

  // ⭐️ 모든 FCM 메시지를 처리하는 중앙 집중 함수
  // 이 함수는 NotificationService 내부에서 호출될 뿐만 아니라,
  // 백그라운드 핸들러(firebaseMessagingBackgroundHandler)에서도 호출됩니다.
  static void handleIncomingMessage(
    RemoteMessage message, {
    bool isForeground = false,
    bool isBackground = false,
    bool isOpenedApp = false,
    bool isInitial = false, // 앱이 종료된 상태에서 처음 열렸는지
  }) {
    print('--- FCM Message Handler ---');
    print('Message ID: ${message.messageId}');
    print(
      'Notification: ${message.notification?.title} / ${message.notification?.body}',
    );
    print('Data: ${message.data}');

    // 'is_dangerous' 데이터 확인
    final isDangerous = message.data['is_dangerous'] == 'true';

    if (isForeground) {
      _handleForegroundMessage(message, isDangerous);
    } else if (isBackground) {
      _handleBackgroundMessage(message, isDangerous);
    } else if (isOpenedApp) {
      _handleOpenedAppMessage(message, isDangerous, isInitial);
    }

    // 모든 상태에서 공통적으로 처리할 로직 (예: 로깅, 데이터 저장)
    if (isDangerous) {
      print("🚨 공통: 위험 상황 감지! 모든 상태에서 수행할 작업");
      // 예: Analytics.logEvent('danger_detected', parameters: message.data);
    }
  }

  // --- 상태별 메시지 처리 상세 함수 ---

  static void _handleForegroundMessage(
    RemoteMessage message,
    bool isDangerous,
  ) {
    print("✅ [Foreground] 메시지 처리");
    if (isDangerous) {
      print("🚨 [Foreground] 위험 상황 처리: 다이얼로그 표시 등");
      _showDangerousSituationDialog(
        message.notification?.title,
        message.notification?.body,
        message.data,
      );
    }
    // 포그라운드에서는 OS가 알림을 띄우지 않으므로, 알림 UI를 보여주고 싶다면
    // flutter_local_notifications와 같은 패키지를 사용하여 직접 로컬 알림을 띄워야 합니다.
  }

  static void _handleBackgroundMessage(
    RemoteMessage message,
    bool isDangerous,
  ) {
    print("✅ [Background] 메시지 처리");
    if (isDangerous) {
      print("🚨 [Background] 위험 상황 처리: 백그라운드 작업 수행");
      // UI 업데이트는 불가능. 로컬 DB 저장, 로깅, flutter_local_notifications로 알림 띄우기 등이 가능
      // 예: LocalDatabase.saveDangerEvent(message.data);
    }
  }

  static void _handleOpenedAppMessage(
    RemoteMessage message,
    bool isDangerous,
    bool isInitial,
  ) {
    print("✅ [OpenedApp] 메시지 처리 (Initial: $isInitial)");
    if (isDangerous) {
      print("🚨 [OpenedApp] 위험 상황 처리: 특정 화면으로 이동 등");
      // 알림 클릭 후 앱이 열렸을 때 특정 화면으로 이동
      if (navigatorKey.currentState != null) {
        // 예: navigatorKey.currentState!.pushNamed('/danger-dashboard', arguments: message.data);
        // 또는 위험 상황 다이얼로그를 다시 띄울 수도 있습니다.
        _showDangerousSituationDialog(
          message.notification?.title,
          message.notification?.body,
          message.data,
        );
      }
    }
  }

  // --- 위험 상황 처리 도우미 함수 (UI 관련) ---
  static void _showDangerousSituationDialog(
    String? title,
    String? body,
    Map<String, dynamic> data,
  ) {
    if (navigatorKey.currentState?.overlay?.context != null) {
      showDialog(
        context: navigatorKey
            .currentState!
            .overlay!
            .context, // NavigatorKey를 통해 현재 컨텍스트를 얻음
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title ?? '🚨 긴급 경고 🚨'),
            content: Text(
              body ?? '위험 상황이 감지되었습니다.\n상세: ${data['alert_type'] ?? '알 수 없음'}',
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      print("⚠️ Warning: No context available to show dialog.");
    }
  }

  // ⭐️ API 서비스에서 호출할 수 있는 예시 함수
  // 예를 들어, 백엔드로부터 WebSocket 등으로 실시간 메시지를 받아와서
  // 앱 내에서 강제로 알림 팝업을 띄우고 싶을 때 사용 가능.
  // 단, 이는 FCM 메시지와는 별개로 앱 내부에서만 동작합니다.
  void showInternalAlert({
    required String title,
    required String message,
    Map<String, dynamic>? data,
  }) {
    print("✨ Internal alert triggered!");
    _showDangerousSituationDialog(title, message, data ?? {});
  }
}

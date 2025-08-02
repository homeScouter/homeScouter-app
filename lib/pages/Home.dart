// lib/pages/home.dart

import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homescouter_app/widgets/sidebar/app_sidebar.dart';
import 'package:homescouter_app/widgets/info/state_message.dart';
import 'package:homescouter_app/widgets/info/state_info_card.dart';
import 'package:homescouter_app/widgets/info/danger_loading.dart';
import '../utils/constant_colors.dart';
import '../widgets/header/header_section.dart';
import 'package:homescouter_app/utils/info_status.dart';

import 'package:homescouter_app/services/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final SidebarXController _sidebarController = SidebarXController(
    selectedIndex: 0,
    extended: true,
  );

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;
  bool isError = false;
  InfoStatus status = InfoStatus.safe;

  // 버튼 애니메이션을 위한 컨트롤러
  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();

    // 버튼 애니메이션 설정
    _buttonAnimationController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );

    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _buttonAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // ⭐️ 초기 상태 확인 로직은 그대로 두지만, `safe` 상태에서는 알림을 강제로 띄우지 않습니다.
    // 이는 FCM 메시지를 통해 전달된 위험 상황에만 반응하도록 합니다.
    // (예: 앱 종료 중 위험 알림을 받았고, 앱을 열었을 때 해당 알림 내용으로 다이얼로그를 띄우고 싶을 때)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 만약 앱이 FCM 알림을 통해 시작되었고, 그 알림이 위험 상태를 나타낸다면
      // NotificationService가 이미 초기 처리를 했을 것입니다.
      // 여기서는 별도의 "초기 위험 알림"을 띄울 필요는 없습니다.
      // _checkInitialDangerStatus(); // 이 부분은 이제 필요 없을 수 있습니다.
    });
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    super.dispose();
  }

  void toggleStatus() {
    // 버튼 누를 때 애니메이션
    _buttonAnimationController.forward().then((_) {
      _buttonAnimationController.reverse();
    });

    setState(() {
      final nextStatus = status == InfoStatus.danger
          ? InfoStatus.safe
          : InfoStatus.danger;

      // ⭐️ 상태가 danger로 변경될 때만 알림 시뮬레이션 함수 호출
      if (nextStatus == InfoStatus.danger) {
        _simulateFCMNotification();
      }
      status = nextStatus;
    });
  }

  // ⭐️ FCM 알림 시뮬레이션 함수 (테스트 버튼/상태 전환용)
  void _simulateFCMNotification() {
    // 위험 상태 알림 메시지를 시뮬레이션합니다.
    final simulatedMessage = RemoteMessage(
      data: {
        'is_dangerous': 'true', // 백엔드에서 보낼 실제 값
        'alert_type': '강제 감지',
        'severity': '높음',
        'timestamp': DateTime.now().toIso8601String(),
      },
      notification: RemoteNotification(
        title: '🔴 홈 스카우터 경고 🔴',
        body: '위험 상태가 감지되었습니다. 앱에서 즉시 확인하세요.',
      ),
    );

    // NotificationService를 통해 메시지 처리 로직을 호출 (포그라운드 상태로 가정)
    // isForeground: true로 설정하여 앱이 현재 포그라운드에 있다고 가정하고 처리합니다.
    NotificationService.handleIncomingMessage(
      simulatedMessage,
      isForeground: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = status == InfoStatus.danger ? "위험 감지 사진" : "안전 상태";
    final subtitle = status == InfoStatus.danger
        ? "사용자의 위험이 감지되는 동작을 확인했습니다."
        : "위험 요소가 감지되지 않았습니다.";
    final chipLabel = status == InfoStatus.danger ? "즉시 확인 필요" : "이상 없음";
    final imageUrl = status == InfoStatus.danger ? "assets/danger.webp" : null;

    return Scaffold(
      key: _scaffoldKey,
      // 배경색을 더 부드럽게
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black12,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          color: Constants.primaryColor,
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Constants.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.security,
                color: Constants.primaryColor,
                size: 20,
              ),
            ),
            SizedBox(width: 8),
            Text(
              'homeScouter',
              style: GoogleFonts.notoSansKr(
                color: Constants.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(child: AppSidebar(controller: _sidebarController)),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderSection(),
            const SizedBox(height: 18.0),
            if (isLoading)
              DangerLoading()
            else if (isError)
              StateMessage(
                message: "알 수 없는 오류가 발생했습니다.\n잠시 후 다시 시도해주세요.",
                isDanger: status == InfoStatus.danger,
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: StateInfoCard(
                  status: status,
                  title: title,
                  subtitle: subtitle,
                  chipLabel: chipLabel,
                  imageUrl: imageUrl,
                ),
              ),
            const SizedBox(height: 32.0),

            // 개선된 버튼
            Center(
              child: AnimatedBuilder(
                animation: _buttonScaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _buttonScaleAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: status == InfoStatus.danger
                              ? [
                                  Constants.safeColor,
                                  Constants.safeColor.withOpacity(0.8),
                                ]
                              : [
                                  Constants.dangerColor,
                                  Constants.dangerColor.withOpacity(0.8),
                                ],
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color:
                                (status == InfoStatus.danger
                                        ? Constants
                                              .safeColor // 안전 상태로 변경 버튼일 때 그림자 색
                                        : Constants
                                              .dangerColor) // 위험 상태로 변경 버튼일 때 그림자 색
                                    .withOpacity(0.4),
                            blurRadius: 12.0,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: toggleStatus,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              status == InfoStatus.danger
                                  ? Icons
                                        .security // 현재 danger 상태 -> 안전으로 변경 버튼
                                  : Icons.warning, // 현재 safe 상태 -> 위험으로 변경 버튼
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              status == InfoStatus.danger
                                  ? "안전 상태로 전환"
                                  : "위험 상태로 전환",
                              style: GoogleFonts.notoSansKr(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20.0), // 버튼 간 간격 추가
            // ⭐️ 테스트용 FCM 알림 시뮬레이션 버튼 (여전히 필요할 수 있습니다)
            Center(
              child: ElevatedButton.icon(
                onPressed: _simulateFCMNotification, // 위에 만든 시뮬레이션 함수 연결
                icon: const Icon(Icons.notifications_active),
                label: Text(
                  '수동 위험 알림 테스트', // 문구 변경
                  style: GoogleFonts.notoSansKr(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.dangerColor.withOpacity(0.8),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
              ),
            ),
            const SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }
}

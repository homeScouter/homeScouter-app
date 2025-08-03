import 'package:flutter/material.dart';
import 'package:homescouter_app/pages/danger__history_page.dart';
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

  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();

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

    // ◼️ 사이드바 인덱스 변경 감지 리스너 등록
    _sidebarController.addListener(_onSidebarChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 기존 알림 초기화 논리
    });
  }

  // ◼️ 메뉴 선택 시 라우팅 처리
  void _onSidebarChanged() {
    final idx = _sidebarController.selectedIndex;
    if (!mounted) return;
    switch (idx) {
      case 0:
        // 홈이므로 자기 자신이므로 별도 라우팅 없음
        break;
      case 1:
        // 기록(위험 기록) → DangerHistoryPage로 이동
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => DangerHistoryPage()),
        );
        break;
      case 2:
        // 설정 메뉴가 있다면 설정 페이지로 이동(없으면 주석 처리)
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(builder: (_) => SettingsPage()),
        // );
        break;
    }
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    _sidebarController.removeListener(_onSidebarChanged); // ◼️ 리스너 해제 중요
    _sidebarController.dispose();
    super.dispose();
  }

  void toggleStatus() {
    _buttonAnimationController.forward().then((_) {
      _buttonAnimationController.reverse();
    });

    setState(() {
      final nextStatus = status == InfoStatus.danger
          ? InfoStatus.safe
          : InfoStatus.danger;

      if (nextStatus == InfoStatus.danger) {
        _simulateFCMNotification();
      }
      status = nextStatus;
    });
  }

  void _simulateFCMNotification() {
    final simulatedMessage = RemoteMessage(
      data: {
        'is_dangerous': 'true',
        'alert_type': '강제 감지',
        'severity': '높음',
        'timestamp': DateTime.now().toIso8601String(),
      },
      notification: RemoteNotification(
        title: '🔴 홈 스카우터 경고 🔴',
        body: '위험 상태가 감지되었습니다. 앱에서 즉시 확인하세요.',
      ),
    );

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
                                        ? Constants.safeColor
                                        : Constants.dangerColor)
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
                                  ? Icons.security
                                  : Icons.warning,
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
            const SizedBox(height: 20.0),
            Center(
              child: ElevatedButton.icon(
                onPressed: _simulateFCMNotification,
                icon: const Icon(Icons.notifications_active),
                label: Text(
                  '수동 위험 알림 테스트',
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

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
  InfoStatus status = InfoStatus.danger;

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
      status = status == InfoStatus.danger
          ? InfoStatus.safe
          : InfoStatus.danger;
    });
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
            const SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }
}

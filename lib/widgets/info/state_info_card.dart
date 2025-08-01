import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homescouter_app/utils/info_status.dart';
import '../../utils/constant_colors.dart';

class StateInfoCard extends StatefulWidget {
  final InfoStatus status;
  final String title;
  final String subtitle;
  final String chipLabel;
  final String? imageUrl;

  const StateInfoCard({
    super.key,
    required this.status,
    required this.title,
    required this.subtitle,
    required this.chipLabel,
    this.imageUrl,
  });

  @override
  State<StateInfoCard> createState() => _StateInfoCardState();
}

class _StateInfoCardState extends State<StateInfoCard>
    with SingleTickerProviderStateMixin {
  // 애니메이션 컨트롤러 (카드가 나타날 때 부드럽게 등장)
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // 애니메이션 설정 (0.4초 동안 실행)
    _animationController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );

    // 크기 애니메이션 (0.9에서 1.0으로)
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack, // 통통 튀는 효과
      ),
    );

    // 투명도 애니메이션 (0에서 1로)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // 애니메이션 시작!
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDanger = widget.status == InfoStatus.danger;

    // 상태에 따른 색상 선택
    final Color chipColor = isDanger
        ? Constants.dangerColor
        : Constants.safeColor;
    final IconData icon = isDanger
        ? Icons.warning_amber_rounded
        : Icons.check_circle_rounded;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                // 상태에 따른 그라데이션 배경
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDanger
                      ? [Colors.red[50]!, Colors.red[100]!.withOpacity(0.7)]
                      : [
                          Colors.green[50]!,
                          Colors.green[100]!.withOpacity(0.7),
                        ],
                ),
                borderRadius: BorderRadius.circular(20.0),
                // 테두리 추가
                border: Border.all(
                  color: chipColor.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              padding: EdgeInsets.all(20.0),
              child: Row(
                children: [
                  // 아이콘 부분을 더 예쁘게
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          chipColor.withOpacity(0.2),
                          chipColor.withOpacity(0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: chipColor, size: 32.0),
                  ),
                  SizedBox(width: 18.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 제목
                        Text(
                          widget.title,
                          style: GoogleFonts.notoSansKr(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                            color: Constants.textPrimary,
                          ),
                        ),
                        SizedBox(height: 6.0),
                        // 부제목
                        Text(
                          widget.subtitle,
                          style: GoogleFonts.notoSansKr(
                            fontSize: 14.0,
                            color: Constants.textSecondary,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 10.0),
                        // 상태 칩 (더 예쁘게)
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                chipColor.withOpacity(0.9),
                                chipColor.withOpacity(0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 6.0,
                          ),
                          child: Text(
                            widget.chipLabel,
                            style: GoogleFonts.notoSansKr(
                              fontSize: 12.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // 이미지나 아이콘 표시 부분
                        if (isDanger && widget.imageUrl != null)
                          Container(
                            margin: EdgeInsets.only(top: 16.0),
                            width: double.infinity,
                            height: 800,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.asset(
                                widget.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[200],
                                    child: Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey[400],
                                        size: 48,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        else if (!isDanger)
                          Container(
                            margin: EdgeInsets.only(top: 16.0),
                            width: double.infinity,
                            height: 120,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.green[50]!, Colors.green[100]!],
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: Colors.green[200]!,
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Constants.safeColor,
                                    size: 48.0,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '안전합니다! 🛡️',
                                    style: GoogleFonts.notoSansKr(
                                      color: Constants.safeColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

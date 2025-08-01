import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/constant_colors.dart';

class HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          // 그라데이션 배경 추가! (더 예뻐집니다)
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Constants.primaryColor,
              Constants.primaryColor.withOpacity(0.8),
              Constants.secondaryColor.withOpacity(0.6),
            ],
          ),
          borderRadius: BorderRadius.circular(20.0),
          // 더 예쁜 그림자 효과
          boxShadow: [
            BoxShadow(
              color: Constants.primaryColor.withOpacity(0.3),
              blurRadius: 20.0,
              offset: Offset(0, 10),
              spreadRadius: 2,
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 아이콘 추가해서 더 친근하게
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  "환영합니다! 사용자 👋",
                  style: GoogleFonts.notoSansKr(
                    color: Colors.white,
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(
              "오늘도 안전하게 지켜드릴게요",
              style: GoogleFonts.notoSansKr(
                color: Colors.white.withOpacity(0.9),
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

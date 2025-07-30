import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white, // 카드 내부 배경
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 16.0,
              offset: Offset(4, 8),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "환영한다 사용자",
              style: GoogleFonts.notoSansKr(
                color: Color(0xFF222438),
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "오늘도 감시 당신의 안전을",
              style: GoogleFonts.notoSansKr(
                color: Colors.grey[800]?.withOpacity(0.75),
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

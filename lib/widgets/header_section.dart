import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 44.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "환영한다 사용자",
            style: GoogleFonts.notoSansKr(
              color: Colors.black,
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6.0),
          Text(
            "오늘도 감시 당신의 안전을",
            style: GoogleFonts.notoSansKr(
              color: Colors.white.withOpacity(0.75),
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}

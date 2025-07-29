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
            "안녕하세요, 사용자님!",
            style: GoogleFonts.notoSansKr(
              color: Colors.white,
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6.0),
          Text(
            "오늘도 안전한 하루 보내세요 🦺",
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

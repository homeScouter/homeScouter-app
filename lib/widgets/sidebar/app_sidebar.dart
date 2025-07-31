import 'package:flutter/material.dart';
import 'package:homescouter_app/pages/Login.dart';
import 'package:homescouter_app/utils/constants.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({Key? key, required this.controller}) : super(key: key);

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        textStyle: GoogleFonts.notoSansKr(
          color: Colors.grey[700],
          fontSize: 14,
        ),
        selectedTextStyle: GoogleFonts.notoSansKr(
          color: Constants.primaryColor,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
        iconTheme: IconThemeData(color: Colors.grey[400], size: 22),
        selectedIconTheme: IconThemeData(
          color: Constants.primaryColor,
          size: 24,
        ),
        selectedItemDecoration: BoxDecoration(
          color: Constants.primaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        itemTextPadding: const EdgeInsets.only(left: 16),
      ),
      extendedTheme: SidebarXTheme(
        width: 190,
        decoration: BoxDecoration(color: Colors.white),
      ),
      headerBuilder: (context, extended) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Constants.primaryColor.withOpacity(0.1),
              child: Icon(
                Icons.account_circle,
                size: 38,
                color: Constants.primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '사용자',
              style: GoogleFonts.notoSansKr(
                color: Constants.primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),

      footerDivider: Divider(
        color: Constants.primaryColor.withOpacity(0.3),
        height: 1,
      ),
      footerBuilder: (context, extended) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: Row(
              children: [
                Icon(Icons.logout, color: Colors.redAccent, size: 22),
                const SizedBox(width: 12),
                Text(
                  '로그아웃',
                  style: GoogleFonts.notoSansKr(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },

      items: const [
        SidebarXItem(icon: Icons.home, label: '홈'),
        SidebarXItem(icon: Icons.search, label: '기록'),
        SidebarXItem(icon: Icons.settings, label: '설정'),
      ],
    );
  }
}

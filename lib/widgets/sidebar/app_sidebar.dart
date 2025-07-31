// sidebar_widget.dart
import 'package:flutter/material.dart';
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
        child: CircleAvatar(
          radius: 28,
          backgroundColor: Constants.primaryColor.withOpacity(0.1),
          child: Icon(
            Icons.account_circle,
            size: 38,
            color: Constants.primaryColor,
          ),
        ),
      ),
      items: const [
        SidebarXItem(icon: Icons.home, label: '홈'),
        SidebarXItem(icon: Icons.search, label: '검색'),
        SidebarXItem(icon: Icons.favorite, label: '즐겨찾기'),
      ],
    );
  }
}

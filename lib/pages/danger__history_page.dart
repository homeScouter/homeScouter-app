import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sidebarx/sidebarx.dart';
import '../widgets/sidebar/app_sidebar.dart';
import '../utils/constant_colors.dart';
import 'home.dart';

class DangerHistoryPage extends StatefulWidget {
  @override
  State<DangerHistoryPage> createState() => _DangerHistoryPageState();
}

class _DangerHistoryPageState extends State<DangerHistoryPage> {
  // 기록은 인덱스 1
  final SidebarXController _sidebarController = SidebarXController(
    selectedIndex: 1,
    extended: true,
  );

  final Map<String, List<String>> dangerPhotosByDate = {
    "2025-07-31": ["assets/danger.webp", "assets/danger.webp"],
    "2025-07-30": ["assets/danger.webp"],
    "2025-07-28": [
      "assets/danger.webp",
      "assets/danger.webp",
      "assets/danger.webp",
    ],
  };

  List<MapEntry<String, String>> get allPhotos {
    final result = <MapEntry<String, String>>[];
    dangerPhotosByDate.forEach((date, images) {
      for (var img in images) {
        result.add(MapEntry(date, img));
      }
    });
    result.sort((a, b) => b.key.compareTo(a.key));
    return result;
  }

  @override
  void initState() {
    super.initState();
    _sidebarController.addListener(_onSidebarChanged);
  }

  @override
  void dispose() {
    _sidebarController.removeListener(_onSidebarChanged);
    _sidebarController.dispose();
    super.dispose();
  }

  void _onSidebarChanged() {
    final idx = _sidebarController.selectedIndex;
    if (!mounted) return;
    switch (idx) {
      case 0:
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => Home()));
        break;
      case 1:
        // 자기 자신이므로 아무 동작 없음
        break;
      case 2:
        // 설정 페이지 라우팅 필요시
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(builder: (_) => SettingsPage()),
        // );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "위험 기록",
          style: GoogleFonts.notoSansKr(
            color: Constants.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(child: AppSidebar(controller: _sidebarController)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildAllPhotosList(context),
      ),
    );
  }

  Widget _buildAllPhotosList(BuildContext context) {
    final entries = allPhotos;
    if (entries.isEmpty) {
      return Center(
        child: Text(
          "저장된 위험 기록이 없습니다.",
          style: GoogleFonts.notoSansKr(
            color: Constants.textSecondary,
            fontSize: 16,
          ),
        ),
      );
    }
    return ListView.separated(
      itemCount: entries.length,
      separatorBuilder: (_, __) => Divider(height: 28, color: Colors.grey[200]),
      itemBuilder: (context, idx) {
        final date = entries[idx].key;
        final imgPath = entries[idx].value;
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imgPath,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            "위험 감지 사진",
            style: GoogleFonts.notoSansKr(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            date,
            style: GoogleFonts.notoSansKr(
              color: Constants.textSecondary,
              fontSize: 13,
            ),
          ),
          trailing: Icon(Icons.chevron_right, color: Constants.primaryColor),
          onTap: () => _openDetailPage(context, imgPath, date),
        );
      },
    );
  }

  void _openDetailPage(BuildContext context, String imgPath, String date) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DangerPhotoDetailPage(imagePath: imgPath, date: date),
      ),
    );
  }
}

// 상세 페이지 코드 (필요 시 별도 파일로 분리해도 OK)
class DangerPhotoDetailPage extends StatelessWidget {
  final String imagePath;
  final String date;

  const DangerPhotoDetailPage({required this.imagePath, required this.date});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "기록 상세",
          style: GoogleFonts.notoSansKr(
            color: Constants.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(imagePath, fit: BoxFit.contain, height: 340),
              ),
              SizedBox(height: 32),
              Text(
                "감지 일시: $date",
                style: GoogleFonts.notoSansKr(
                  color: Constants.textSecondary,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "위험 감지 사진입니다.\n상세 내용은 추후 추가 가능합니다.",
                style: GoogleFonts.notoSansKr(
                  fontSize: 15,
                  color: Constants.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

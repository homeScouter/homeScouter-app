import 'package:flutter/material.dart';
import 'package:homescouter_app/widgets/danger/danger_error.dart';
import 'package:homescouter_app/widgets/danger/danger_info_card.dart';
import 'package:homescouter_app/widgets/danger/danger_loading.dart';
import '../utils/constants.dart';
import '../widgets/header_section.dart'; // 헤더 위젯 임포트

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 하드코딩 샘플값
    final bool isLoading = false;
    final bool isError = false;
    final bool isDanger = true;
    final String title = "위험 감지 사진";
    final String subtitle = "사용자의 위험이 감지되는 동작을 확인했습니다.";
    final String chipLabel = "즉시 확인 필요";
    final String imageUrl =
        "https://cdn.pixabay.com/photo/2023/11/24/12/06/duck-8409886_1280.png";

    return Scaffold(
      backgroundColor: Constants.primaryColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderSection(), // 헤더 위젯 사용!
            SizedBox(height: 18.0),
            if (isLoading)
              DangerLoading()
            else if (isError)
              DangerError(message: "알 수 없는 오류가 발생했습니다.\n잠시 후 다시 시도해주세요.")
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: DangerInfoCard(
                  isDanger: isDanger,
                  title: title,
                  subtitle: subtitle,
                  chipLabel: chipLabel,
                  imageUrl: imageUrl,
                ),
              ),
            SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }
}

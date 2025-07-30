import 'package:flutter/material.dart';
import 'package:homescouter_app/widgets/info/state_message.dart';
import 'package:homescouter_app/widgets/info/state_info_card.dart';
import 'package:homescouter_app/widgets/info/danger_loading.dart';
import '../utils/constants.dart';
import '../widgets/header_section.dart'; // 헤더 위젯 임포트
import 'package:homescouter_app/utils/info_status.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = false;
  bool isError = false;
  InfoStatus status = InfoStatus.danger;

  void toggleStatus() {
    setState(() {
      status = status == InfoStatus.danger
          ? InfoStatus.safe
          : InfoStatus.danger;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 상태별 텍스트 및 데이터 분기
    final title = status == InfoStatus.danger ? "위험 감지 사진" : "안전 상태";
    final subtitle = status == InfoStatus.danger
        ? "사용자의 위험이 감지되는 동작을 확인했습니다."
        : "위험 요소가 감지되지 않았습니다.";
    final chipLabel = status == InfoStatus.danger ? "즉시 확인 필요" : "이상 없음";
    final imageUrl = status == InfoStatus.danger
        ? "assets/danger.webp"
        : null; // 안전상태는 이미지 없음

    return Scaffold(
      backgroundColor: Constants.primaryColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderSection(),
            SizedBox(height: 18.0),
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
            SizedBox(height: 32.0),
            Center(
              child: ElevatedButton(
                onPressed: toggleStatus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: status == InfoStatus.danger
                      ? Colors.green
                      : Colors.redAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  status == InfoStatus.danger ? "안전 상태로 전환" : "위험 상태로 전환",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }
}

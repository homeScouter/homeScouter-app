import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homescouter_app/utils/info_status.dart';

class StateInfoCard extends StatelessWidget {
  final InfoStatus status;
  final String title;
  final String subtitle;
  final String chipLabel;
  final String? imageUrl; // 위험상태는 이미지, 안전상태는 아이콘 도식화

  const StateInfoCard({
    super.key,
    required this.status,
    required this.title,
    required this.subtitle,
    required this.chipLabel,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDanger = status == InfoStatus.danger;
    final Color chipColor = isDanger ? Colors.redAccent : Colors.green;
    final IconData icon = isDanger
        ? Icons.warning_amber_rounded
        : Icons.check_circle_rounded;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 16.0,
            offset: Offset(4, 8),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30.0,
            backgroundColor: chipColor.withOpacity(0.1),
            child: Icon(icon, color: chipColor, size: 32.0),
          ),
          SizedBox(width: 18.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.notoSansKr(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF222438),
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  subtitle,
                  style: GoogleFonts.notoSansKr(
                    fontSize: 13.0,
                    color: Colors.grey[700],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.0),
                Container(
                  decoration: BoxDecoration(
                    color: chipColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 3.0,
                  ),
                  child: Text(
                    chipLabel,
                    style: GoogleFonts.notoSansKr(
                      fontSize: 12.0,
                      color: chipColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isDanger && imageUrl != null)
                  Container(
                    margin: EdgeInsets.only(top: 12.0),
                    width: double.infinity,
                    height: 700,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      image: DecorationImage(
                        image: NetworkImage(imageUrl!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else if (!isDanger)
                  Container(
                    margin: EdgeInsets.only(top: 24.0),
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 60.0,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

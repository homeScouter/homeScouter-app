import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DangerInfoCard extends StatelessWidget {
  final bool isDanger;
  final String title;
  final String subtitle;
  final String chipLabel;
  final String imageUrl;

  const DangerInfoCard({
    required this.isDanger,
    required this.title,
    required this.subtitle,
    required this.chipLabel,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = isDanger ? Colors.redAccent : Colors.green;

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
            child: Icon(
              isDanger ? Icons.warning_amber_rounded : Icons.security_rounded,
              color: chipColor,
              size: 32.0,
            ),
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
                Row(
                  children: [
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
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 12.0),
                  width: double.infinity,
                  height: 700,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
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

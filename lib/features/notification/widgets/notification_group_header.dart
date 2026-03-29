import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class NotificationGroupHeader extends StatelessWidget {
  final String title;

  const NotificationGroupHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Text(
        title,
        style: GoogleFonts.urbanist(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.grey500,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../data/notificaiton_model.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;

  const NotificationItem({super.key, required this.notification, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRead = notification.isRead;

    return InkWell(
      onTap: onTap,
      splashColor: AppColors.primary.withOpacity(0.06),
      highlightColor: AppColors.primary.withOpacity(0.04),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        color: isRead
            ? Colors.transparent
            : (isDark
                  ? AppColors.primary.withOpacity(0.06)
                  : AppColors.bgPrimary.withOpacity(0.5)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Emoji icon ──
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: isDark ? AppColors.dark4 : AppColors.grey100,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Center(
                child: Text(
                  notification.emoji,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // ── Content ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: GoogleFonts.urbanist(
                            fontSize: 15,
                            fontWeight: isRead
                                ? FontWeight.w500
                                : FontWeight.w700,
                            color: isDark ? AppColors.white : AppColors.grey900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Unread dot
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    notification.body,
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: isDark ? AppColors.grey400 : AppColors.grey600,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    notification.time,
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.grey600 : AppColors.grey400,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 6),
            Icon(
              Icons.chevron_right_rounded,
              color: isDark ? AppColors.grey600 : AppColors.grey400,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

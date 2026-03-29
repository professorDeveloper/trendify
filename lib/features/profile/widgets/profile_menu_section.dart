import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../data/profile_menu_item.dart';

class ProfileMenuSection extends StatelessWidget {
  final List<ProfileMenuItem> items;

  const ProfileMenuSection({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          final isLast = i == items.length - 1;
          return Column(
            children: [
              ProfileMenuTile(item: items[i]),
              if (!isLast)
                const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 52,
                  color: Color(0xFFF2F2F2),
                ),
            ],
          );
        }),
      ),
    );
  }
}

class ProfileMenuTile extends StatelessWidget {
  final ProfileMenuItem item;

  const ProfileMenuTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(item.icon, size: 22, color: AppColors.grey700),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                item.label,
                style: GoogleFonts.urbanist(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey900,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                size: 20, color: AppColors.grey400),
          ],
        ),
      ),
    );
  }
}
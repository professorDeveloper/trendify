import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendify/core/theme/app_colors.dart';

import '../../../core/constants.dart';
import 'hot_deal_card.dart';

class TypeKeywordView extends StatelessWidget {
  final List<String> recentSearches;
  final VoidCallback onClearAll;
  final ValueChanged<int> onRemoveRecent;
  final ValueChanged<String> onRecentTap;

  const TypeKeywordView({
    super.key,
    required this.recentSearches,
    required this.onClearAll,
    required this.onRemoveRecent,
    required this.onRecentTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (recentSearches.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Searches',
                  style: GoogleFonts.urbanist(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.grey900,
                  ),
                ),
                GestureDetector(
                  onTap: onClearAll,
                  child: const Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentSearches.length,
              separatorBuilder: (_, __) =>
              const Divider(height: 1, color: Color(0xFFF0F0F0)),
              itemBuilder: (_, i) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  recentSearches[i],
                  style: GoogleFonts.urbanist(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey700,
                  ),
                ),
                trailing: GestureDetector(
                  onTap: () => onRemoveRecent(i),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: AppColors.grey400,
                  ),
                ),
                onTap: () => onRecentTap(recentSearches[i]),
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
          ],
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hot Deals This Week',
                style: GoogleFonts.urbanist(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.grey900,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Text(
                      'View All',
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: Constants.products.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) => HotDealCard(
                product: Constants.products[i],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
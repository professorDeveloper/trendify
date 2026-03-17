import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants.dart';
import '../../../../core/theme/app_colors.dart';

class CategoryTabs extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onTap;

  const CategoryTabs({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
        scrollDirection: Axis.horizontal,
        itemCount: Constants.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isActive = selected == index;
          return GestureDetector(
            onTap: () => onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive ? AppColors.primary : AppColors.grey300,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  Constants.categories[index],
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color: isActive ? AppColors.white : AppColors.grey600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

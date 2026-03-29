import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../data/order_item.dart';

class OrderTabs extends StatelessWidget {
  final OrderTab selected;
  final int activeCount;
  final int completedCount;
  final int canceledCount;
  final void Function(OrderTab) onTap;

  const OrderTabs({
    super.key,
    required this.selected,
    required this.activeCount,
    required this.completedCount,
    required this.canceledCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF6F6F6),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                _TabItem(
                  label: 'Active ($activeCount)',
                  isSelected: selected == OrderTab.active,
                  onTap: () => onTap(OrderTab.active),
                ),
                const SizedBox(width: 8),
                _TabItem(
                  label: 'Completed ($completedCount)',
                  isSelected: selected == OrderTab.completed,
                  onTap: () => onTap(OrderTab.completed),
                ),
                const SizedBox(width: 8),
                _TabItem(
                  label: 'Canceled ($canceledCount)',
                  isSelected: selected == OrderTab.canceled,
                  onTap: () => onTap(OrderTab.canceled),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.urbanist(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.white : AppColors.grey500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
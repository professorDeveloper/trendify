import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendify/core/theme/app_colors.dart';

const _sortOptions = [
  'Most Suitable',
  'Popularity',
  'Top Rated',
  'Price High to Low',
  'Price Low to High',
  'Latest Arrival',
  'Discount',
];

class SortBottomSheet extends StatefulWidget {
  final String selectedSort;
  final ValueChanged<String> onSortSelected;

  const SortBottomSheet({
    super.key,
    required this.selectedSort,
    required this.onSortSelected,
  });

  @override
  State<SortBottomSheet> createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedSort;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Sort',
            style: GoogleFonts.urbanist(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.grey900,
            ),
          ),
          const SizedBox(height: 16),
          ..._sortOptions.map(
            (opt) => _SortTile(
              option: opt,
              selected: _selected == opt,
              onTap: () {
                setState(() => _selected = opt);
                widget.onSortSelected(opt);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SortTile extends StatelessWidget {
  final String option;
  final bool selected;
  final VoidCallback onTap;

  const _SortTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.grey400,
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            Text(
              option,
              style: GoogleFonts.urbanist(
                fontSize: 15,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? AppColors.grey900 : AppColors.grey700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SortFilterBar extends StatelessWidget {
  final VoidCallback onSortTap;
  final VoidCallback onFilterTap;

  const SortFilterBar({
    super.key,
    required this.onSortTap,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.grey200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _BarButton(
              icon: Icons.sort_rounded,
              label: 'Sort',
              onTap: onSortTap,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _BarButton(
              icon: Icons.tune_rounded,
              label: 'Filter',
              onTap: onFilterTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _BarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BarButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: AppColors.grey700),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.urbanist(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.grey700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

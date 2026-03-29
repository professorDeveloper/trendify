import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendify/features/favorite/widgets/favorite_product_card.dart';

import '../../../../core/constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../home/data/models/product_model.dart';
import '../home/presentation/widgets/category_tabs.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  int _selectedCategory = 0;
  late List<ProductModel> _products;
  final ScrollController _scrollController = ScrollController();
  bool _fabVisible = true;

  @override
  void initState() {
    super.initState();
    _products = List.from(Constants.products);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final visible =
        _scrollController.position.userScrollDirection.name != 'reverse';
    if (visible != _fabVisible) setState(() => _fabVisible = visible);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<ProductModel> get _filtered {
    if (_selectedCategory == 0) return _products;
    final cat = Constants.categories[_selectedCategory];
    return _products.where((p) => p.category == cat).toList();
  }

  int get _favoriteCount => _products.where((p) => p.isFavorite).length;

  void _toggleFavorite(String id) {
    setState(() {
      final idx = _products.indexWhere((p) => p.name == id);
      if (idx != -1) _products[idx].isFavorite = !_products[idx].isFavorite;
    });
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _SortBottomSheet(
        selectedSort: 'Most Suitable',
        onSortSelected: (_) {},
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.white,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AnimatedSlide(
          offset: _fabVisible ? Offset.zero : const Offset(0, 2),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: AnimatedOpacity(
            opacity: _fabVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: IgnorePointer(
              ignoring: !_fabVisible,
              child: _SortFilterBar(
                onSortTap: _showSortSheet,
                onFilterTap: _showFilterSheet,
              ),
            ),
          ),
        ),
        appBar: _buildAppBar(),
        body: Column(
          children: [
            const SizedBox(height: 8),
            CategoryTabs(
              selected: _selectedCategory,
              onTap: (i) => setState(() => _selectedCategory = i),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filtered.isEmpty
                  ? const _EmptyState()
                  : GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 20,
                            childAspectRatio: 0.58,
                          ),
                      itemCount: filtered.length,
                      itemBuilder: (_, index) {
                        final p = filtered[index];
                        return FavoriteProductCard(
                          imageUrl: p.imageUrl,
                          name: p.name,
                          price: p.price,
                          rating: p.rating,
                          isFavorite: p.isFavorite,
                          onFavoriteTap: () => _toggleFavorite(p.name),
                          onTap: () {},
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'Wishlist ($_favoriteCount)',
        style: GoogleFonts.urbanist(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.grey900,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded, color: AppColors.grey900),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.more_vert_rounded, color: AppColors.grey900),
          onPressed: () {},
        ),
      ],
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }
}

// ─── Empty State ────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.favorite_border_rounded,
            size: 72,
            color: AppColors.grey300,
          ),
          const SizedBox(height: 16),
          Text(
            'No items in wishlist',
            style: GoogleFonts.urbanist(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Items you save will appear here',
            style: GoogleFonts.urbanist(fontSize: 14, color: AppColors.grey400),
          ),
        ],
      ),
    );
  }
}

// ─── Sort & Filter Floating Bar ─────────────────────────────────────────────

class _SortFilterBar extends StatelessWidget {
  final VoidCallback onSortTap;
  final VoidCallback onFilterTap;

  const _SortFilterBar({required this.onSortTap, required this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _BarItem(
            icon: Icons.swap_vert_rounded,
            label: 'Sort',
            onTap: onSortTap,
            showDivider: true,
          ),
          _BarItem(
            icon: Icons.tune_rounded,
            label: 'Filter',
            onTap: onFilterTap,
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool showDivider;

  const _BarItem({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Row(
              children: [
                Icon(icon, size: 18, color: AppColors.grey800),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey800,
                  ),
                ),
              ],
            ),
          ),
          if (showDivider)
            Container(width: 1, height: 20, color: AppColors.grey300),
        ],
      ),
    );
  }
}

// ─── Sort Bottom Sheet ───────────────────────────────────────────────────────

class _SortBottomSheet extends StatefulWidget {
  final String selectedSort;
  final ValueChanged<String> onSortSelected;

  const _SortBottomSheet({
    required this.selectedSort,
    required this.onSortSelected,
  });

  @override
  State<_SortBottomSheet> createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<_SortBottomSheet> {
  late String _selected;

  static const _options = [
    'Most Suitable',
    'Popularity',
    'Top Rated',
    'Price High to Low',
    'Price Low to High',
    'Latest Arrival',
    'Discount',
  ];

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
          ..._options.map(
            (opt) => InkWell(
              onTap: () {
                setState(() => _selected = opt);
                widget.onSortSelected(opt);
                Navigator.pop(context);
              },
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
                          color: _selected == opt
                              ? AppColors.primary
                              : AppColors.grey400,
                          width: 2,
                        ),
                      ),
                      child: _selected == opt
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
                      opt,
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        fontWeight: _selected == opt
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: _selected == opt
                            ? AppColors.grey900
                            : AppColors.grey700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Filter Bottom Sheet ─────────────────────────────────────────────────────

class _FilterBottomSheet extends StatefulWidget {
  const _FilterBottomSheet();

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  RangeValues _priceRange = const RangeValues(50, 300);
  final List<String> _selectedSizes = [];
  int _selectedRating = 0;

  static const _sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Center(
            child: Text(
              'Filter',
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.grey900,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Price Range',
            style: GoogleFonts.urbanist(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.grey900,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${_priceRange.start.toInt()}',
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey600,
                ),
              ),
              Text(
                '\$${_priceRange.end.toInt()}',
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey600,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.grey200,
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withOpacity(0.15),
              trackHeight: 3,
            ),
            child: RangeSlider(
              values: _priceRange,
              min: 0,
              max: 500,
              onChanged: (v) => setState(() => _priceRange = v),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Size',
            style: GoogleFonts.urbanist(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.grey900,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _sizes.map((size) {
              final isSelected = _selectedSizes.contains(size);
              return GestureDetector(
                onTap: () => setState(() {
                  isSelected
                      ? _selectedSizes.remove(size)
                      : _selectedSizes.add(size);
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 48,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.grey300,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      size,
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppColors.white : AppColors.grey700,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text(
            'Rating',
            style: GoogleFonts.urbanist(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.grey900,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(5, (i) {
              final star = i + 1;
              return GestureDetector(
                onTap: () => setState(() => _selectedRating = star),
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Icon(
                    Icons.star_rounded,
                    size: 30,
                    color: star <= _selectedRating
                        ? AppColors.warning
                        : AppColors.grey300,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Text(
                'Apply Filter',
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

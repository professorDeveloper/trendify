import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendify/features/search/widgets/hot_deal_card.dart';
import 'package:trendify/features/search/widgets/not_found.dart';
import 'package:trendify/features/search/pages/camera_scan_page.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../core/constants.dart';
import '../../home/data/models/product_model.dart';
import '../../home/presentation/widgets/category_tabs.dart';
import '../widgets/search_product_card.dart' show ProductCard;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  List<String> _recentSearches = ['Hoodie for Men', 'Nike', 'Polo Shirt'];
  String _searchQuery = '';
  bool _notFound = false;
  int _selectedCategory = 0;
  String _selectedSort = 'Most Suitable';
  bool _fabVisible = true;

  @override
  void initState() {
    super.initState();
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
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    final query = value.trim();
    if (query.isEmpty) return;

    if (!_recentSearches.contains(query)) {
      setState(() {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 5) {
          _recentSearches = _recentSearches.sublist(0, 5);
        }
      });
    }

    final found = Constants.products.any(
          (p) => p.name.toLowerCase().contains(query.toLowerCase()),
    );

    setState(() {
      _searchQuery = query;
      _notFound = !found;
      _selectedCategory = 0;
      _fabVisible = true;
    });
    _focusNode.unfocus();
  }

  void _clearSearch() {
    setState(() {
      _controller.clear();
      _searchQuery = '';
      _notFound = false;
    });
    _focusNode.requestFocus();
  }

  List<ProductModel> get _filteredProducts => Constants.products
      .where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()))
      .toList();

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _SortBottomSheet(
        selectedSort: _selectedSort,
        onSortSelected: (val) => setState(() => _selectedSort = val),
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
    return Scaffold(
      backgroundColor: AppColors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _searchQuery.isNotEmpty && !_notFound
          ? AnimatedSlide(
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
      )
          : null,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  InkWell(
                    focusColor: AppColors.grey200,
                    borderRadius: BorderRadius.circular(100),
                    onTap: () => Navigator.pop(context),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20,
                        color: AppColors.grey900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.grey100,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _controller,
                        builder: (_, value, __) => TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          autofocus: true,
                          textInputAction: TextInputAction.search,
                          onSubmitted: _onSearch,
                          style: GoogleFonts.urbanist(
                            fontSize: 15,
                            color: AppColors.grey900,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search Trends...',
                            hintStyle: GoogleFonts.urbanist(
                              fontSize: 15,
                              color: AppColors.grey400,
                            ),
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: AppColors.grey400,
                              size: 20,
                            ),
                            suffixIcon: value.text.isNotEmpty
                                ? GestureDetector(
                              onTap: _clearSearch,
                              child: const Icon(
                                Icons.close_rounded,
                                color: AppColors.grey400,
                                size: 20,
                              ),
                            )
                                : GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CameraScanPage(),
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                color: AppColors.grey400,
                                size: 20,
                              ),
                            ),
                            filled: true,
                            fillColor: AppColors.grey100,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _searchQuery.isEmpty
                  ? _buildTypeKeywordState()
                  : _notFound
                  ? NotFoundView()
                  : _buildResultsState(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeKeywordState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_recentSearches.isNotEmpty) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Searches',
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.grey900,
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _recentSearches.clear()),
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
              itemCount: _recentSearches.length,
              separatorBuilder: (_, __) =>
              const Divider(height: 1, color: Color(0xFFF0F0F0)),
              itemBuilder: (_, i) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  _recentSearches[i],
                  style: GoogleFonts.urbanist(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey600,
                  ),
                ),
                trailing: GestureDetector(
                  onTap: () => setState(() => _recentSearches.removeAt(i)),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: AppColors.grey400,
                  ),
                ),
                onTap: () {
                  _controller.text = _recentSearches[i];
                  _controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: _recentSearches[i].length),
                  );
                  _onSearch(_recentSearches[i]);
                },
              ),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hot Deals This Week',
                style: GoogleFonts.urbanist(
                  fontSize: 16,
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
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 15,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 210,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: Constants.products.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) =>
                  HotDealCard(product: Constants.products[i]),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildResultsState() {
    final products = _filteredProducts;
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: _CategoryTabsDelegate(
            selected: _selectedCategory,
            onTap: (i) => setState(() => _selectedCategory = i),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              mainAxisSpacing: 16,
              crossAxisSpacing: 12,
            ),
            delegate: SliverChildBuilderDelegate(
                  (_, i) => ProductCard(product: products[i], onTap: () {}),
              childCount: products.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryTabsDelegate extends SliverPersistentHeaderDelegate {
  final int selected;
  final ValueChanged<int> onTap;

  const _CategoryTabsDelegate({required this.selected, required this.onTap});

  @override
  double get minExtent => 58;

  @override
  double get maxExtent => 58;

  @override
  bool shouldRebuild(_CategoryTabsDelegate old) =>
      old.selected != selected;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: CategoryTabs(selected: selected, onTap: onTap),
    );
  }
}

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
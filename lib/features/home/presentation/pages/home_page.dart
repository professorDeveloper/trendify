import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendify/core/constants.dart';
import 'package:trendify/core/theme/app_colors.dart';
import 'package:trendify/features/home/data/models/category_model.dart';
import 'package:trendify/features/home/presentation/widgets/new_arrial_section.dart';
import 'package:trendify/features/search/pages/search_page.dart';

import '../widgets/category_tabs.dart';
import '../widgets/product_grid.dart';
import '../widgets/promo_banner.dart';
import 'category_detail_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,

        title: Text(
          'Deep Space',
          style: GoogleFonts.urbanist(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.grey900,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.notifications_outlined,
                  color: AppColors.grey900,
                  size: 24,
                ),
                Positioned(
                  top: -1,
                  right: -1,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search_rounded,
                        color: AppColors.grey500,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Search Trends...',
                        style: GoogleFonts.urbanist(
                          fontSize: 15,
                          color: AppColors.grey500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const PromoBanner(),
            const SizedBox(height: 20),
            CategoryTabs(
              selected: _selectedCategory,
              onTap: (i) => setState(() => _selectedCategory = i),
            ),
            const SizedBox(height: 18),
            ProductGrid(),
            const SizedBox(height: 18),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _CategorySection(),
            ),
            const SizedBox(height: 16),
            NewArrivalSection(
              products: Constants.products,
              title: "New Arrival",
              onViewAll: () {},
            ),
            SizedBox(height: 16),
            NewArrivalSection(
              products: List.of(Constants.products)..shuffle(),
              title: "Hot Deals This Week",
              onViewAll: () {},
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.3,
      ),
      itemCount: Constants.categoryCards.length,
      itemBuilder: (context, index) {
        return _CategoryCard(category: Constants.categoryCards[index]);
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryModel category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryDetailScreen(
              category: category,
              products: Constants.products,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(14),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                category.label,
                style: GoogleFonts.urbanist(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey900,
                ),
              ),
            ),
            Positioned(
              right: -2,
              bottom: -6,
              child: category.imageUrl.isNotEmpty
                  ? Image.asset(
                      category.imageUrl,
                      width: 90,
                      height: 90,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const SizedBox(width: 70, height: 70),
                    )
                  : const SizedBox(width: 70, height: 70),
            ),
          ],
        ),
      ),
    );
  }
}

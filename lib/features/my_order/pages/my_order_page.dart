import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../data/order_item.dart';
import '../data/order_data.dart';
import '../widgets/order_tabs.dart';
import '../widgets/order_card.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  OrderTab _selectedTab = OrderTab.completed;

  final List<OrderItem> _orders = OrderData.orders;

  List<OrderItem> get _filtered =>
      _orders.where((o) => o.tab == _selectedTab).toList();

  int _countFor(OrderTab tab) => _orders.where((o) => o.tab == tab).length;

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F6F6),
        appBar: _buildAppBar(),
        body: Column(
          children: [
            OrderTabs(
              selected: _selectedTab,
              activeCount: _countFor(OrderTab.active),
              completedCount: _countFor(OrderTab.completed),
              canceledCount: _countFor(OrderTab.canceled),
              onTap: (tab) => setState(() => _selectedTab = tab),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => OrderCard(
                  order: filtered[i],
                  currentTab: _selectedTab,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF6F6F6),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.all(14),
        child: SvgPicture.asset(
          'assets/images/logo.svg',
          colorFilter: const ColorFilter.mode(
            AppColors.primary,
            BlendMode.srcIn,
          ),
          errorBuilder: (_, __, ___) => Container(
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.eco, color: AppColors.white, size: 16),
          ),
        ),
      ),
      title: Text(
        'My Order',
        style: GoogleFonts.urbanist(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: AppColors.grey900,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded,
              color: AppColors.grey900, size: 24),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.more_vert_rounded,
              color: AppColors.grey900, size: 24),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.receipt_long_outlined,
              size: 72, color: AppColors.grey300),
          const SizedBox(height: 16),
          Text(
            'No orders yet',
            style: GoogleFonts.urbanist(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your orders will appear here',
            style: GoogleFonts.urbanist(
                fontSize: 14, color: AppColors.grey400),
          ),
        ],
      ),
    );
  }
}
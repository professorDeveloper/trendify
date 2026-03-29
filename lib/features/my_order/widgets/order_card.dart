import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../data/order_item.dart';
import 'order_filled_button.dart';

class OrderCard extends StatelessWidget {
  final OrderItem order;
  final OrderTab currentTab;

  const OrderCard({
    super.key,
    required this.order,
    required this.currentTab,
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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.shopping_bag_outlined,
                    size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  order.date,
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey700,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: const Icon(Icons.more_vert_rounded,
                      size: 20, color: AppColors.grey500),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    order.imageUrl,
                    width: 80,
                    height: 96,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 80,
                      height: 96,
                      decoration: BoxDecoration(
                        color: AppColors.grey100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.image_not_supported_outlined,
                          color: AppColors.grey400, size: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.mainProductName,
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.grey900,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (order.otherProductsCount > 0) ...[
                        const SizedBox(height: 4),
                        Text(
                          '+${order.otherProductsCount} other product${order.otherProductsCount > 1 ? 's' : ''}',
                          style: GoogleFonts.urbanist(
                            fontSize: 12,
                            color: AppColors.grey500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        'Total Shopping',
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: AppColors.grey500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '\$${order.totalPrice.toStringAsFixed(2)}',
                        style: GoogleFonts.urbanist(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildActionButton(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    if (currentTab == OrderTab.active) {
      return OrderOutlineButton(label: 'Track Order', onTap: () {});
    }
    if (currentTab == OrderTab.completed) {
      return order.hasReview
          ? OrderOutlineButton(label: 'Edit Review', onTap: () {})
          : OrderFilledButton(label: 'Leave a Review', onTap: () {});
    }
    if (currentTab == OrderTab.canceled) {
      return OrderFilledButton(label: 'Re-order', onTap: () {});
    }
    return const SizedBox.shrink();
  }
}
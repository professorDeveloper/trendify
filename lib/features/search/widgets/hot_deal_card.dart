import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendify/core/theme/app_colors.dart';
import 'package:trendify/features/home/data/models/product_model.dart';
import 'package:trendify/features/search/widgets/search_product_card.dart';

class HotDealCard extends StatefulWidget {
  final ProductModel product;

  const HotDealCard({super.key, required this.product});

  @override
  State<HotDealCard> createState() => _HotDealCardState();
}

class _HotDealCardState extends State<HotDealCard> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    widget.product.imageUrl,
                    width: 130,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.grey200,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.grey400,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: RatingBadge(rating: widget.product.rating),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: FavoriteButton(
                    isFavorite: _isFavorite,
                    onToggle: () => setState(() => _isFavorite = !_isFavorite),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.grey900,
            ),
          ),
          Text(
            widget.product.price as String,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
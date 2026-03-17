import 'package:flutter/cupertino.dart';
import 'package:trendify/features/home/presentation/widgets/product_card.dart';

import '../../../../core/constants.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: Constants.products.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              right: index < Constants.products.length - 1 ? 12 : 0,
            ),
            child:  SizedBox(
              width: 155,
              child: ProductCard(product: Constants.products[index]),
            ),
          );
        },
      ),
    );
  }
}
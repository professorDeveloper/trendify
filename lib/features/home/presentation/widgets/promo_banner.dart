import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class PromoBanner extends StatefulWidget {
  const PromoBanner({super.key});

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  late final PageController _controller;
  final List<String> _banners = [
    'assets/images/promo_banner.png',
    'assets/images/promo_banner.png',
    'assets/images/promo_banner.png',
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.9,initialPage: 1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: PageView.builder(

        controller: _controller,
        itemCount: _banners.length,
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                _banners[index],
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: Container(
          height: 28,
          width: 28,
          child: SvgPicture.asset("assets/images/logo.svg",
          color: AppColors.primary,width: 10,height: 10,),
        ),
        title: Text(
          'Cart (4)',
          style: GoogleFonts.urbanist(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.grey900,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.search, color: AppColors.grey900, size: 24),
          ),
        ],
      ),
      body: ListView(children: []),
    );
  }
}

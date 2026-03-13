import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trendify/core/theme/app_colors.dart';

class MainBottomNavbar extends StatefulWidget {
  const MainBottomNavbar({super.key});

  @override
  State<MainBottomNavbar> createState() => _MainBottomNavbarState();
}

class _MainBottomNavbarState extends State<MainBottomNavbar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        unselectedItemColor: AppColors.grey500,
        selectedItemColor: AppColors.primary,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: _buildIcon("assets/icons/home.svg", 0),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: _buildIcon("assets/icons/favorite.svg", 1),
            label: "Wishlist",
          ),
          BottomNavigationBarItem(
            icon: _buildIcon("assets/icons/cart.svg", 2),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: _buildIcon("assets/icons/order.svg", 3),
            label: "My Order",
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(String assetPath, int index) {
    final color = _selectedIndex == index ? AppColors.primary : AppColors.grey500;
    return SvgPicture.asset(
      assetPath,
      width: 22,
      height: 22,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
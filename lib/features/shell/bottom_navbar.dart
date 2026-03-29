import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trendify/core/theme/app_colors.dart';
import 'package:trendify/features/cart/pages/cart_page.dart';
import 'package:trendify/features/favorite/favorite_page.dart';
import 'package:trendify/features/my_order/pages/my_order_page.dart';
import 'package:trendify/features/profile/pages/profile_page.dart';

import '../home/presentation/pages/home_page.dart';

class MainBottomNavbar extends StatefulWidget {
  const MainBottomNavbar({super.key});

  @override
  State<MainBottomNavbar> createState() => _MainBottomNavbarState();
}

class _MainBottomNavbarState extends State<MainBottomNavbar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    FavoriteScreen(),
    CartScreen(),
    MyOrderScreen(),
    ProfileScreen(),
    // WishlistPage(),
    // CartPage(),
    // OrderPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
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

          BottomNavigationBarItem(
            icon: _buildIcon("assets/images/profile.png", 4  ),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(String assetPath, int index) {
    final isActive = _selectedIndex == index;
    final color = isActive ? AppColors.primary : AppColors.grey500;

    return assetPath.contains(".svg")
        ? SvgPicture.asset(
            assetPath,
            width: 22,
            height: 22,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          )
        : Image.asset(assetPath, width: 22, height: 22);
  }
}

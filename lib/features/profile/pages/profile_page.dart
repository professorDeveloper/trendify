import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../data/profile_menu_item.dart';
import '../data/profile_user.dart';
import '../widgets/profile_card.dart';
import '../widgets/profile_menu_section.dart';
import '../widgets/profile_logout_button.dart';
import '../widgets/qr_bottom_sheet.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileUser _user = ProfileUserData.currentUser;

  void _showQrSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => QrBottomSheet(qrData: _user.email),
    );
  }

  List<ProfileMenuItem> get _accountItems => [
    ProfileMenuItem(
      icon: Icons.location_on_outlined,
      label: 'Manage Addresses',
      onTap: () {},
    ),
    ProfileMenuItem(
      icon: Icons.credit_card_outlined,
      label: 'Payment Methods',
      onTap: () {},
    ),
    ProfileMenuItem(
      icon: Icons.shield_outlined,
      label: 'Account & Security',
      onTap: () {},
    ),
  ];

  List<ProfileMenuItem> get _generalItems => [
    ProfileMenuItem(
      icon: Icons.person_outline_rounded,
      label: 'My Profile',
      onTap: () {},
    ),
    ProfileMenuItem(
      icon: Icons.notifications_outlined,
      label: 'Notifications',
      onTap: () {},
    ),
    ProfileMenuItem(
      icon: Icons.swap_vert_rounded,
      label: 'Linked Accounts',
      onTap: () {},
    ),
    ProfileMenuItem(
      icon: Icons.remove_red_eye_outlined,
      label: 'App Appearance',
      onTap: () {},
    ),
    ProfileMenuItem(
      icon: Icons.insert_chart_outlined_rounded,
      label: 'Data & Analytics',
      onTap: () {},
    ),
    ProfileMenuItem(
      icon: Icons.help_outline_rounded,
      label: 'Help & Support',
      onTap: () {},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F6F6),
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            children: [
              ProfileCard(user: _user, onQrTap: _showQrSheet),
              const SizedBox(height: 16),
              ProfileMenuSection(items: _accountItems),
              const SizedBox(height: 16),
              ProfileMenuSection(items: _generalItems),
              const SizedBox(height: 16),
              ProfileLogoutButton(onTap: () {}),
            ],
          ),
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
        'Account',
        style: GoogleFonts.urbanist(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: AppColors.grey900,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: IconButton(
            icon: const Icon(Icons.qr_code_scanner_rounded,
                color: AppColors.grey900, size: 24),
            onPressed: _showQrSheet,
          ),
        ),
      ],
    );
  }
}
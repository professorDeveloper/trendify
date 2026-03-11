import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendify/features/auth/pages/sign_in_page.dart';
import 'package:trendify/features/auth/pages/sign_up_page.dart';

import '../../../core/theme/app_colors.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 90,
            left: 12,
            right: 12,
            child: Column(
              children: [
                SvgPicture.asset(
                  "assets/images/logo.svg",
                  color: AppColors.primary,
                  height: 80,
                  width: 80,
                ),
                SizedBox(height: 38),
                Text(
                  "Let's Get Started!",
                  style: GoogleFonts.urbanist(
                    fontSize: 32,
                    color: AppColors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Let's dive in into your account!",
                  style: GoogleFonts.urbanist(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 52),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: BorderSide(color: AppColors.bgPrimary, width: 1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 15,
                    ),
                    minimumSize: const Size(double.infinity, 52),
                  ),
                  onPressed: () {},
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Centered text
                      Text(
                        'Continue with Google',
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: AppColors.grey900,
                        ),
                      ),
                      // Icon pinned to the left
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          "assets/images/google.png",
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: BorderSide(color: AppColors.bgPrimary, width: 1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 15,
                    ),
                    minimumSize: const Size(double.infinity, 52),
                  ),
                  onPressed: () {},
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Centered text
                      Text(
                        'Continue with Apple',
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: AppColors.grey900,
                        ),
                      ),
                      // Icon pinned to the left
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          "assets/images/apple.png",
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: BorderSide(color: AppColors.bgPrimary, width: 1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 15,
                    ),
                    minimumSize: const Size(double.infinity, 52),
                  ),
                  onPressed: () {},
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Centered text
                      Text(
                        'Continue with Facebook',
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: AppColors.grey900,
                        ),
                      ),
                      // Icon pinned to the left
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          "assets/images/facebook.png",
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: BorderSide(color: AppColors.bgPrimary, width: 1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 15,
                    ),
                    minimumSize: const Size(double.infinity, 52),
                  ),
                  onPressed: () {},
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Centered text
                      Text(
                        'Continue with Twitter',
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: AppColors.grey900,
                        ),
                      ),
                      // Icon pinned to the left
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          "assets/images/twitter.png",
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 52),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: const Text(
                    "Sign up",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.bgPrimary,
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: const Text(
                    "Sign in",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 0,
            left: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Privacy Policy",
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 6),
                Text(
                  "•",
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 6),
                Text(
                  "Terms of Service",
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

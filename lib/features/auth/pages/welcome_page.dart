import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendify/core/constants.dart';
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
                  Constants.logoPath,
                  color: AppColors.primary,
                  height: 80,
                  width: 80,
                ),
                SizedBox(height: 38),
                Text(
                  Constants.welcomeTitle,
                  style: GoogleFonts.urbanist(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  Constants.welcomeSubtitle,
                  style: GoogleFonts.urbanist(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 52),
                _socialButton(Constants.continueWithGoogle, Constants.googleIconPath),
                SizedBox(height: 12),
                _socialButton(Constants.continueWithApple, Constants.appleIconPath),
                SizedBox(height: 12),
                _socialButton(Constants.continueWithFacebook, Constants.facebookIconPath),
                SizedBox(height: 12),
                _socialButton(Constants.continueWithTwitter, Constants.twitterIconPath),
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
                    Constants.signUp,
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
                    Constants.signIn,
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
                  Constants.privacyPolicy,
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
                  Constants.termsOfService,
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

  Widget _socialButton(String label, String iconPath) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        side: BorderSide(color: AppColors.bgPrimary, width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        minimumSize: const Size(double.infinity, 52),
      ),
      onPressed: () {},
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.urbanist(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(iconPath, height: 24, width: 24),
          ),
        ],
      ),
    );
  }
}
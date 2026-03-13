import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendify/core/constants.dart';
import 'package:trendify/core/theme/app_colors.dart';
import 'package:trendify/features/shell/bottom_navbar.dart';

import '../../widgets/auth_widgets.dart';

class ResetSuccessScreen extends StatefulWidget {
  const ResetSuccessScreen({super.key});

  @override
  State<ResetSuccessScreen> createState() => _ResetSuccessScreenState();
}

class _ResetSuccessScreenState extends State<ResetSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/circle_success.png",
              width: 120,
              height: 120,
            ),
            SizedBox(height: 18),
            Text(
              textAlign: TextAlign.center,
              Constants.youAreSet,
              style: GoogleFonts.urbanist(
                fontSize: 26,
                color: AppColors.grey900,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              textAlign: TextAlign.center,
              Constants.successPasswordReset,
              style: GoogleFonts.urbanist(
                fontSize: 18,
                color: AppColors.grey700,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16),
        child: AuthButton(
          label: "Go to Homepage",
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainBottomNavbar()),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendify/features/onboarding/pages/intro_page.dart';

import '../../../core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initSplash();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.infoPrimary,
      body: Stack(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/logo.svg",
                  height: 135,
                  width: 135,
                ),
                SizedBox(height: 24),
                Text(
                  "Trendify",
                  style: GoogleFonts.urbanist(
                    fontSize: 36,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                strokeWidth: 6,
                strokeCap: StrokeCap.round,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void initSplash() async {
    Future.delayed(Duration(seconds: 2)).then(
      (value) => {
        if (mounted)
          {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => IntroScreen(),
                traversalEdgeBehavior: TraversalEdgeBehavior.parentScope,
                directionalTraversalEdgeBehavior:
                    TraversalEdgeBehavior.closedLoop,
              ),
            ),
          },
      },
    );
  }
}

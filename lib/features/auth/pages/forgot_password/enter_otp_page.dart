import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:trendify/features/auth/pages/forgot_password/new_password_page.dart';

import '../../../../core/constants.dart';
import '../../../../core/theme/app_colors.dart';

class EnterOtpScreen extends StatefulWidget {
  const EnterOtpScreen({super.key});

  @override
  State<EnterOtpScreen> createState() => _EnterOtpScreenState();
}

class _EnterOtpScreenState extends State<EnterOtpScreen> {
  final pinController = PinInputController();
  int second = 60;
  bool canResend = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    pinController.dispose();
    super.dispose();
  }

  void startTimer() {
    setState(() {
      second = 60;
      canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (second == 0) {
        timer.cancel();
        setState(() {
          canResend = true;
        });
      } else {
        setState(() {
          second -= 1;
        });
      }
    });
  }

  void resendOtp() {
    if (!canResend) return;
    pinController.clear();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.grey900),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Constants.otpTitle,
              style: GoogleFonts.urbanist(
                fontSize: 27,
                fontWeight: FontWeight.w700,
                color: AppColors.grey900,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              Constants.otpSubtitle,
              style: GoogleFonts.urbanist(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: AppColors.grey600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  MaterialPinFormField(
                    length: 4,
                    pinController: pinController,
                    theme: MaterialPinTheme(
                      borderWidth: 1,
                      focusedFillColor: AppColors.grey50,
                      followingFillColor: AppColors.grey50,
                      filledBorderColor: AppColors.bgPrimary,
                      fillColor: AppColors.grey50,
                      filledFillColor: AppColors.grey50,
                      borderColor: AppColors.grey50,
                      shape: MaterialPinShape.outlined,
                    ),
                    validator: (value) {
                      if (value == null || value.length < 4) {
                        return 'Please enter all 4 digits';
                      }
                      return null;
                    },
                    onCompleted: (value) => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewPasswordScreen(),
                        ),
                      ),
                    },
                  ),
                  const SizedBox(height: 16),
                  canResend
                      ? GestureDetector(
                          onTap: resendOtp,
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                color: AppColors.grey700,
                              ),
                              text: "Didn't receive the code? ",
                              children: [
                                TextSpan(
                                  text: "Resend",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : RichText(
                          text: TextSpan(
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              color: AppColors.grey700,
                            ),
                            text: "You can resend the code in",
                            children: [
                              WidgetSpan(child: SizedBox(width: 4)),
                              TextSpan(
                                text: second.toString(),
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              WidgetSpan(child: SizedBox(width: 4)),
                              TextSpan(
                                text: "seconds",
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  color: AppColors.grey700,
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
            const Spacer(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

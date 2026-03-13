import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    required this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: GoogleFonts.urbanist(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.grey900,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.urbanist(
          fontSize: 14,
          color: AppColors.grey500,
        ),
        prefixIcon: Icon(prefixIcon, color: AppColors.grey500, size: 20),
        suffixIcon: suffixIcon != null
            ? IconButton(
          icon: Icon(suffixIcon, color: AppColors.grey500, size: 20),
          onPressed: onSuffixTap,
        )
            : null,
      ),
      validator: validator,
    );
  }
}

class AuthButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const AuthButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onTap;

  const SocialButton({
    super.key,
    required this.iconPath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        side: const BorderSide(color: AppColors.bgPrimary, width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        minimumSize: const Size(double.infinity, 52),
      ),
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
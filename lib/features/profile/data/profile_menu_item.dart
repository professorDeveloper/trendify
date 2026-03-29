import 'package:flutter/material.dart';

class ProfileMenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}
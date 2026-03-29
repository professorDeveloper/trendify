import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final String size;
  final Color color;
  int quantity;
  bool isSelected;

  CartItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.size = 'L',
    this.color = Colors.black,
    this.quantity = 1,
    this.isSelected = true,
  });
}

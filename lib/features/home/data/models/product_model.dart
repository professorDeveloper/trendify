import 'package:flutter/material.dart';

class ProductModel {
  final String name;
  final String price;
  final double rating;
  final String imageUrl;

  const ProductModel({
    required this.name,
    required this.price,
    required this.rating,
    this.imageUrl = '',
  });
}
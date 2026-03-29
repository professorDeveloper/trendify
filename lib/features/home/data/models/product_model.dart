class ProductModel {
  final String name;
  final String price;
  final double rating;
  final String imageUrl;
  final String category;
  bool isFavorite;

  ProductModel({
    required this.name,
    required this.price,
    required this.rating,
    this.imageUrl = '',
    this.category = 'Discover',
    this.isFavorite = false,
  });
}
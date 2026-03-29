class WishlistProduct {
  final String id;
  final String imageUrl;
  final String name;
  final double price;
  final double rating;
  final String category;
  bool isFavorite;

  WishlistProduct({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.rating,
    required this.category,
    this.isFavorite = true,
  });
}

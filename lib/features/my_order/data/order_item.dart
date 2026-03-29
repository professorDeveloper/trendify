enum OrderTab { active, completed, canceled }

class OrderItem {
  final String id;
  final String date;
  final String mainProductName;
  final String imageUrl;
  final int otherProductsCount;
  final double totalPrice;
  final OrderTab tab;
  final bool hasReview;

  const OrderItem({
    required this.id,
    required this.date,
    required this.mainProductName,
    required this.imageUrl,
    required this.otherProductsCount,
    required this.totalPrice,
    required this.tab,
    this.hasReview = false,
  });
}
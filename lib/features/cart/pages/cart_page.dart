import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../data/cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<CartItem> _items = [
    CartItem(
      id: '1',
      name: 'Urban Blend Long Sleeve Shirt',
      imageUrl: 'assets/images/woman.png',
      price: 185.00,
      size: 'L',
      color: Colors.black,
    ),
    CartItem(
      id: '2',
      name: 'Street Style Comfort Tee',
      imageUrl: 'assets/images/man.png',
      price: 155.00,
      size: 'L',
      color: Colors.black,
    ),
    CartItem(
      id: '3',
      name: 'Elite Style Modal Elegance',
      imageUrl: 'assets/images/product5.png',
      price: 190.00,
      size: 'L',
      color: Colors.black,
    ),
    CartItem(
      id: '4',
      name: 'Luxe Blend Formal Wear',
      imageUrl: 'assets/images/product6.png',
      price: 160.00,
      size: 'M',
      color: Colors.black,
    ),
  ];

  int get _selectedCount => _items.where((i) => i.isSelected).length;

  double get _totalPrice => _items
      .where((i) => i.isSelected)
      .fold(0, (sum, i) => sum + i.price * i.quantity);

  void _toggleSelect(String id) {
    setState(() {
      final idx = _items.indexWhere((i) => i.id == id);
      if (idx != -1) _items[idx].isSelected = !_items[idx].isSelected;
    });
  }

  void _removeItem(String id) {
    setState(() => _items.removeWhere((i) => i.id == id));
  }

  void _incrementQty(String id) {
    setState(() {
      final idx = _items.indexWhere((i) => i.id == id);
      if (idx != -1) _items[idx].quantity++;
    });
  }

  void _decrementQty(String id) {
    setState(() {
      final idx = _items.indexWhere((i) => i.id == id);
      if (idx != -1 && _items[idx].quantity > 1) _items[idx].quantity--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F6F6),
        appBar: _buildAppBar(),
        body: Stack(
          children: [
            _items.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              itemCount: _items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _CartCard(
                item: _items[i],
                onSelectTap: () => _toggleSelect(_items[i].id),
                onEditTap: () => _showEditSheet(_items[i]),
                onDeleteTap: () => _confirmDelete(_items[i]),
                onIncrement: () => _incrementQty(_items[i].id),
                onDecrement: () => _decrementQty(_items[i].id),
              ),
            ),

            // Checkout button
            if (_items.isNotEmpty)
              Positioned(
                bottom: 24,
                left: 16,
                right: 16,
                child: _CheckoutButton(
                  count: _selectedCount,
                  total: _totalPrice,
                  onTap: () {},
                ),
              ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF6F6F6),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.all(14),
        child: SvgPicture.asset(
          'assets/images/logo.svg',
          colorFilter: const ColorFilter.mode(
            AppColors.primary,
            BlendMode.srcIn,
          ),
          errorBuilder: (_, __, ___) => Container(
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.eco, color: AppColors.white, size: 16),
          ),
        ),
      ),
      title: Text(
        'Cart (${_items.length})',
        style: GoogleFonts.urbanist(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: AppColors.grey900,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: IconButton(
            icon: const Icon(Icons.search_rounded,
                color: AppColors.grey900, size: 24),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  void _showEditSheet(CartItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _EditSheet(item: item, onSave: (size, qty) {
        setState(() {
          item.quantity = qty;
        });
      }),
    );
  }

  void _confirmDelete(CartItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _DeleteSheet(
        name: item.name,
        onDelete: () {
          Navigator.pop(context);
          _removeItem(item.id);
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_bag_outlined,
              size: 72, color: AppColors.grey300),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: GoogleFonts.urbanist(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Add items to get started',
            style: GoogleFonts.urbanist(
                fontSize: 14, color: AppColors.grey400),
          ),
        ],
      ),
    );
  }
}

// ─── Cart Card ────────────────────────────────────────────────────────────────

class _CartCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onSelectTap;
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _CartCard({
    required this.item,
    required this.onSelectTap,
    required this.onEditTap,
    required this.onDeleteTap,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox
            GestureDetector(
              onTap: onSelectTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 24,
                height: 24,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: item.isSelected ? AppColors.primary : AppColors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: item.isSelected
                        ? AppColors.primary
                        : AppColors.grey300,
                    width: 1.5,
                  ),
                ),
                child: item.isSelected
                    ? const Icon(Icons.check_rounded,
                    color: AppColors.white, size: 16)
                    : null,
              ),
            ),

            const SizedBox(width: 12),

            // Product image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                item.imageUrl,
                width: 90,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 90,
                  height: 110,
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.image_not_supported_outlined,
                      color: AppColors.grey400, size: 32),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + edit/delete
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.grey900,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: onEditTap,
                            child: const Icon(Icons.edit_outlined,
                                size: 18, color: AppColors.grey500),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: onDeleteTap,
                            child: const Icon(Icons.delete_outline_rounded,
                                size: 18, color: Color(0xFFE53935)),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Size
                  Text(
                    'Size: ${item.size}',
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      color: AppColors.grey500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 2),

                  // Color
                  Row(
                    children: [
                      Text(
                        'Color: ',
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: AppColors.grey500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: item.color,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.grey300, width: 0.5),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  // Qty + stepper
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Qty: ${item.quantity}',
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: AppColors.grey500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // Qty stepper
                      Row(
                        children: [
                          _QtyButton(
                            icon: Icons.remove,
                            onTap: onDecrement,
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              '${item.quantity}',
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.grey900,
                              ),
                            ),
                          ),
                          _QtyButton(
                            icon: Icons.add,
                            onTap: onIncrement,
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Price
                  Text(
                    '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: AppColors.grey700),
      ),
    );
  }
}


class _CheckoutButton extends StatelessWidget {
  final int count;
  final double total;
  final VoidCallback onTap;

  const _CheckoutButton({
    required this.count,
    required this.total,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Checkout ($count) - \$${total.toStringAsFixed(2)}',
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}


class _EditSheet extends StatefulWidget {
  final CartItem item;
  final void Function(String size, int qty) onSave;

  const _EditSheet({required this.item, required this.onSave});

  @override
  State<_EditSheet> createState() => _EditSheetState();
}

class _EditSheetState extends State<_EditSheet> {
  late String _selectedSize;
  late int _qty;

  static const _sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.item.size;
    _qty = widget.item.quantity;
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 16, 20, MediaQuery.of(context).viewInsets.bottom + (bottomPadding > 0 ? bottomPadding : 16) + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'Edit Item',
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.grey900,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Size',
              style: GoogleFonts.urbanist(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.grey900)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: _sizes.map((s) {
              final sel = s == _selectedSize;
              return GestureDetector(
                onTap: () => setState(() => _selectedSize = s),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 48,
                  height: 40,
                  decoration: BoxDecoration(
                    color: sel ? AppColors.primary : AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: sel ? AppColors.primary : AppColors.grey300),
                  ),
                  child: Center(
                    child: Text(s,
                        style: GoogleFonts.urbanist(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: sel ? AppColors.white : AppColors.grey700,
                        )),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Text('Quantity',
              style: GoogleFonts.urbanist(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.grey900)),
          const SizedBox(height: 12),
          Row(
            children: [
              _QtyButton(
                  icon: Icons.remove,
                  onTap: () => setState(() {
                    if (_qty > 1) _qty--;
                  })),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('$_qty',
                    style: GoogleFonts.urbanist(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.grey900)),
              ),
              _QtyButton(
                  icon: Icons.add,
                  onTap: () => setState(() => _qty++)),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                widget.onSave(_selectedSize, _qty);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: Text('Save Changes',
                  style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeleteSheet extends StatelessWidget {
  final String name;
  final VoidCallback onDelete;
  final VoidCallback onCancel;

  const _DeleteSheet({
    required this.name,
    required this.onDelete,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, (bottomPadding > 0 ? bottomPadding : 16) + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Icon(Icons.delete_outline_rounded,
              size: 48, color: Color(0xFFE53935)),
          const SizedBox(height: 12),
          Text(
            'Remove Item?',
            style: GoogleFonts.urbanist(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.grey900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Are you sure you want to remove\n"$name" from your cart?',
            textAlign: TextAlign.center,
            style: GoogleFonts.urbanist(
                fontSize: 14, color: AppColors.grey500),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.grey300),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text('Cancel',
                      style: GoogleFonts.urbanist(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.grey700)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onDelete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text('Remove',
                      style: GoogleFonts.urbanist(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
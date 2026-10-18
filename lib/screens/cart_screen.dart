import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, String>>? cartItems;
  final Function(Map<String, String>)? onAdd;
  final Function(Map<String, String>)? onRemove;

  const CartScreen({
    super.key,
    this.cartItems,
    this.onAdd,
    this.onRemove,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  static const Color orange = Color(0xFFFF6048);
  static const Color textColor = Color(0xFF19202D);
  static const Color muted = Color(0xFF98A2B3);

  late List<Map<String, String>> items;
  final Map<String, int> quantities = {};


  @override
  void initState() {
    super.initState();

    items = List<Map<String, String>>.from(widget.cartItems ?? []);

    for (final item in items) {
      quantities[item['name'] ?? ''] ??= 1;
    }
  }

  int get subtotal {
    int total = 0;

    for (final item in items) {
      final price = int.tryParse(item['price'] ?? '0') ?? 0;
      final quantity = quantities[item['name'] ?? ''] ?? 1;
      total += price * quantity;
    }

    return total;
  }

  int get deliveryFee => items.isEmpty ? 0 : 25;

  int get total => subtotal + deliveryFee;

  void increase(Map<String, String> item) {
    setState(() {
      final name = item['name'] ?? '';
      quantities[name] = (quantities[name] ?? 1) + 1;
    });

    widget.onAdd?.call(item);
  }

  void decrease(Map<String, String> item) {
    final name = item['name'] ?? '';

    if ((quantities[name] ?? 1) > 1) {
      setState(() {
        quantities[name] = quantities[name]! - 1;
      });

      widget.onRemove?.call(item);
    }
  }

  void removeItem(Map<String, String> item) {
    setState(() {
      items.remove(item);
      quantities.remove(item['name'] ?? '');
    });

    widget.onRemove?.call(item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 28, 22, 20),
                children: [
                  const Text(
                    'Your Cart',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${items.fold<int>(0, (sum, item) => sum + (quantities[item['name'] ?? ''] ?? 1))} items · $total EGP',
                    style: const TextStyle(
                      fontSize: 14,
                      color: muted,
                    ),
                  ),
                  const SizedBox(height: 26),

                  if (items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: Column(
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 65,
                            color: muted,
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Your cart is empty',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Add something delicious!',
                            style: TextStyle(color: muted),
                          ),
                        ],
                      ),
                    )
                  else
                    ...items.map(_cartItem),

                  if (items.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _orderSummary(),
                  ],
                ],
              ),
            ),

            if (items.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 10, 22, 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Checkout will be connected next.',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: orange,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: Text(
                      'Proceed to Checkout · $total EGP',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _cartItem(Map<String, String> item) {
    final name = item['name'] ?? 'Product';
    final brand = item['brand'] ?? '';
    final category = item['category'] ?? '';
    final price = int.tryParse(item['price'] ?? '0') ?? 0;
    final quantity = quantities[name] ?? 1;
    final image = item['image'];

    return Dismissible(
      key: ValueKey('$name-${items.indexOf(item)}'),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 14),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(22),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) => removeItem(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.035),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: buildProductImage(image ?? ''),
            ),            const SizedBox(width: 13),
            Expanded(
              child: SizedBox(
                height: 88,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$brand · $category',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: muted,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$price EGP',
                      style: const TextStyle(
                        color: orange,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(height: 48),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _quantityButton(
                      icon: Icons.remove,
                      onTap: () => decrease(item),
                      isMinus: true,
                    ),
                    SizedBox(
                      width: 29,
                      child: Center(
                        child: Text(
                          '$quantity',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    _quantityButton(
                      icon: Icons.add,
                      onTap: () => increase(item),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget buildProductImage(String image) {
    if (image.isEmpty) {
      return _imagePlaceholder();
    }

    if (image.startsWith('http://') ||
        image.startsWith('https://')) {
      return Image.network(
        image,
        width: 88,
        height: 88,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _imagePlaceholder();
        },
      );
    }

    return Image.asset(
      image,
      width: 88,
      height: 88,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _imagePlaceholder();
      },
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 88,
      height: 88,
      color: const Color(0xFFF0F2F4),
      child: const Icon(
        Icons.local_cafe_outlined,
        size: 35,
        color: muted,
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isMinus = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isMinus
              ? const Color(0xFFE9ECF0)
              : orange,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 19,
          color: isMinus ? const Color(0xFF667085) : Colors.white,
        ),
      ),
    );
  }

  Widget _orderSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Order summary',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _summaryRow('Subtotal', '$subtotal EGP'),
          const SizedBox(height: 14),
          _summaryRow('Delivery fee', '$deliveryFee EGP'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Divider(color: Color(0xFFEEF0F2)),
          ),
          _summaryRow(
            'Total',
            '$total EGP',
            bold: true,
            highlighted: true,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
      String label,
      String value, {
        bool bold = false,
        bool highlighted = false,
      }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: bold ? textColor : muted,
              fontSize: 14,
              fontWeight: bold ? FontWeight.w800 : FontWeight.normal,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: highlighted ? orange : textColor,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

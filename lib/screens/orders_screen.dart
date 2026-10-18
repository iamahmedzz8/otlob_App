import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  static const Color orange = Color(0xFFFF6048);
  static const Color textColor = Color(0xFF19202D);
  static const Color muted = Color(0xFF98A2B3);

  static const List<Map<String, dynamic>> orders = [
    {
      'id': '#10245',
      'date': '15 Aug 2026',
      'status': 'Delivered',
      'items': 3,
      'delivery': 'Express',
      'total': 560,
      'images': [
        'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=200',
        'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=200',
      ],
    },
    {
      'id': '#10189',
      'date': '12 Aug 2026',
      'status': 'Processing',
      'items': 3,
      'delivery': 'Standard',
      'total': 415,
      'images': [
        'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=200',
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=200',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF7F9FA),
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
          children: [
            const Text(
              'My Orders',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              '2 orders',
              style: TextStyle(
                fontSize: 14,
                color: muted,
              ),
            ),
            const SizedBox(height: 26),
            ...orders.map((order) => _orderCard(order)),
          ],
        ),
      ),
    );
  }

  Widget _orderCard(Map<String, dynamic> order) {
    final bool delivered = order['status'] == 'Delivered';

    final Color statusColor = delivered
        ? const Color(0xFF16834A)
        : const Color(0xFFE87520);

    final Color statusBackground = delivered
        ? const Color(0xFFE5F5EC)
        : const Color(0xFFFFF2DF);

    final List<String> images =
    List<String>.from(order['images'] as List);

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(27),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Order ${order['id']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      order['status'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            order['date'] as String,
            style: const TextStyle(
              color: muted,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: images.map((imageUrl) {
              return Padding(
                padding: const EdgeInsets.only(right: 9),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    width: 51,
                    height: 51,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        width: 51,
                        height: 51,
                        color: const Color(0xFFF0F2F4),
                        child: const Icon(
                          Icons.local_cafe_outlined,
                          color: muted,
                        ),
                      );
                    },
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Divider(color: Color(0xFFEEF0F2)),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '${order['items']} items',
                style: const TextStyle(
                  color: muted,
                  fontSize: 13,
                ),
              ),
              const Text(
                ' · ',
                style: TextStyle(color: muted),
              ),
              Expanded(
                child: Text(
                  order['delivery'] as String,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                '${order['total']} EGP',
                style: const TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
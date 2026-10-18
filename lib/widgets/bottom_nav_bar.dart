import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final int cartCount;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.cartCount,
    required this.onTap,
  });

  static const Color activeColor = Color(0xFFFF654F);

  static const List<IconData> icons = [
    Icons.home_filled,
    Icons.restaurant_rounded,
    Icons.search_rounded,
    Icons.shopping_bag_outlined,
    Icons.receipt_long_rounded,
    Icons.person_outline_rounded,
  ];

  static const List<String> labels = [
    'Home',
    'Restaurant',
    'Explore',
    'Cart',
    'Orders',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 9, bottom: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: List.generate(icons.length, (index) {
          final selected = selectedIndex == index;

          return Expanded(
            child: InkWell(
              onTap: () => onTap(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        icons[index],
                        size: 22,
                        color: selected
                            ? activeColor
                            : const Color(0xFF92949A),
                      ),
                      if (index == 3 && cartCount > 0)
                        Positioned(
                          right: -9,
                          top: -7,
                          child: Container(
                            constraints: const BoxConstraints(
                              minWidth: 17,
                              minHeight: 17,
                            ),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF654F),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$cartCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    labels[index],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9,
                      color: selected
                          ? activeColor
                          : const Color(0xFF92949A),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
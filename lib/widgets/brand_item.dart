import 'package:flutter/material.dart';

class BrandItem extends StatelessWidget {
  final String name;
  final bool selected;
  final VoidCallback onTap;

  const BrandItem({
    super.key,
    required this.name,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 19,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFFFF0EC)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? const Color(0xFFFF654F)
                : Colors.transparent,
          ),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: selected
                ? const Color(0xFFFF654F)
                : const Color(0xFF252936),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
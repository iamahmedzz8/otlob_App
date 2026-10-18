import 'package:flutter/material.dart';
import 'products_screen.dart';
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  static const Color orange = Color(0xFFFF6048);
  static const Color muted = Color(0xFF98A2B3);
  static const Color textColor = Color(0xFF202127);

  int selectedCategory = -1;
  int selectedBrand = -1;

  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Frappuccino',
      'emoji': '🥤',
      'color': const Color(0xFFFFF0EF),
    },
    {
      'name': 'Latte',
      'emoji': '☕',
      'color': const Color(0xFFFFF8E7),
    },
    {
      'name': 'Mocha',
      'emoji': '🍫',
      'color': const Color(0xFFF0F2F4),
    },
    {
      'name': 'Macchiato',
      'emoji': '☕',
      'color': const Color(0xFFF4F1FF),
    },
    {
      'name': 'Matcha',
      'emoji': '🍵',
      'color': const Color(0xFFE9FBF4),
    },
    {
      'name': 'Cake',
      'emoji': '🍰',
      'color': const Color(0xFFFFF1F6),
    },
    {
      'name': 'Donuts',
      'emoji': '🍩',
      'color': const Color(0xFFFFF5EB),
    },
    {
      'name': 'Salad',
      'emoji': '🥗',
      'color': const Color(0xFFEDF5FF),
    },
  ];

  final List<Map<String, String>> brands = [
    {'name': 'Starbucks', 'letter': 'S'},
    {'name': 'Costa', 'letter': 'C'},
    {'name': 'Cilantro', 'letter': 'C'},
    {'name': 'TBS', 'letter': 'T'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFFFAFAFA),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(22, 35, 22, 24),
        children: [
          const Text(
            'Explore',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: textColor,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Browse by category or brand',
            style: TextStyle(
              fontSize: 16,
              color: muted,
            ),
          ),
          const SizedBox(height: 30),

          _sectionTitle('CATEGORIES'),
          const SizedBox(height: 18),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: 78,
            ),
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategory == index;

              return Material(
                color: category['color'] as Color,
                borderRadius: BorderRadius.circular(24),
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductsScreen(
                          initialCategory: category['name'] as String,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                    ),
                    child: Row(
                      children: [
                        Text(
                          category['emoji'] as String,
                          style: const TextStyle(fontSize: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            category['name'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            size: 17,
                            color: orange,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 38),

          _sectionTitle('BRANDS'),
          const SizedBox(height: 18),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: brands.length,
            separatorBuilder: (_, __) =>
            const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final brand = brands[index];
              final isSelected = selectedBrand == index;

              return Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductsScreen(
                          initialBrand: brand['name']!,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 87,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 17,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: isSelected
                          ? Border.all(
                        color: orange,
                        width: 1.3,
                      )
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.025),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 53,
                          height: 53,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3F1),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            brand['letter']!,
                            style: const TextStyle(
                              color: orange,
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 17),
                        Expanded(
                          child: Text(
                            brand['name']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: Color(0xFFCBD2DC),
                          size: 23,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: muted,
        fontSize: 13,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
      ),
    );
  }
}


import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  final String? initialBrand;
  final String? initialCategory;
  final Function(Map<String, String>)? onAddToCart;

  const ProductsScreen({
    super.key,
    this.initialBrand,
    this.initialCategory,
    this.onAddToCart,
  });

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  static const Color orange = Color(0xFFFF6048);
  static const Color background = Color(0xFFF7F9FA);

  final TextEditingController searchController = TextEditingController();

  String sortOption = 'Relevance';
  String searchQuery = '';
  bool showFilter = false;

  late String brand;
  late String category;

  final List<Map<String, String>> allProducts = [
    {
      'name': 'Vanilla Latte',
      'brand': 'Costa',
      'category': 'Latte',
      'price': '120',
      'image':
      'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=600',
    },
    {
      'name': 'Dark Chocolate Mocha',
      'brand': 'Costa',
      'category': 'Mocha',
      'price': '145',
      'image':
      'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=600',
    },
    {
      'name': 'Caramel Latte',
      'brand': 'Costa',
      'category': 'Latte',
      'price': '135',
      'image':
      'https://images.unsplash.com/photo-1570968915860-54d5c301fa9f?w=600',
    },
    {
      'name': 'Cappuccino',
      'brand': 'Costa',
      'category': 'Latte',
      'price': '125',
      'image':
      'https://images.unsplash.com/photo-1534778101976-62847782c213?w=600',
    },
    {
      'name': 'Double Caramel Frappuccino',
      'brand': 'Starbucks',
      'category': 'Frappuccino',
      'price': '200',
      'image':
      'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=600',
    },
    {
      'name': 'Matcha Latte',
      'brand': 'Starbucks',
      'category': 'Matcha',
      'price': '165',
      'image':
      'https://images.unsplash.com/photo-1515823064-d6e0c04616a7?w=600',
    },
    {
      'name': 'Chocolate Mocha',
      'brand': 'Cilantro',
      'category': 'Mocha',
      'price': '145',
      'image':
      'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=600',
    },
    {
      'name': 'Classic Latte',
      'brand': 'TBS',
      'category': 'Latte',
      'price': '110',
      'image':
      'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=600',
    },
  ];

  @override
  void initState() {
    super.initState();
    brand = widget.initialBrand ?? '';
    category = widget.initialCategory ?? '';
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get filteredProducts {
    List<Map<String, String>> result = allProducts.where((product) {
      final matchesBrand =
          brand.isEmpty || product['brand'] == brand;

      final matchesCategory =
          category.isEmpty || product['category'] == category;

      final query = searchQuery.toLowerCase();

      final matchesSearch =
          product['name']!.toLowerCase().contains(query) ||
              product['brand']!.toLowerCase().contains(query) ||
              product['category']!.toLowerCase().contains(query);

      return matchesBrand && matchesCategory && matchesSearch;
    }).toList();

    switch (sortOption) {
      case 'Price ↑':
        result.sort(
              (a, b) => int.parse(a['price']!)
              .compareTo(int.parse(b['price']!)),
        );
        break;
      case 'Price ↓':
        result.sort(
              (a, b) => int.parse(b['price']!)
              .compareTo(int.parse(a['price']!)),
        );
        break;
      case 'A – Z':
        result.sort(
              (a, b) => a['name']!.compareTo(b['name']!),
        );
        break;
    }

    return result;
  }

  void addProduct(Map<String, String> product) {
    if (widget.onAddToCart != null) {
      widget.onAddToCart!(product);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product['name']} added to cart'),
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connect this screen to the cart in HomeScreen'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = filteredProducts;

    final title = brand.isNotEmpty
        ? brand
        : category.isNotEmpty
        ? category
        : 'Products';

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
                children: [
                  Row(
                    children: [
                      _iconButton(
                        icon: Icons.arrow_back_ios_new,
                        onTap: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF19202D),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 54,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.search,
                                color: Color(0xFF98A2B3),
                                size: 23,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: searchController,
                                  onChanged: (value) {
                                    setState(() {
                                      searchQuery = value;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Search products...',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF98A2B3),
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                              if (searchQuery.isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    searchController.clear();
                                    setState(() {
                                      searchQuery = '';
                                    });
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.grey,
                                    size: 19,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _iconButton(
                        icon: Icons.filter_alt_outlined,
                        onTap: () {
                          setState(() {
                            showFilter = !showFilter;
                          });
                        },
                        showDot: true,
                      ),
                    ],
                  ),

                  if (showFilter) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Filter by brand',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            children: [
                              'All',
                              'Costa',
                              'Starbucks',
                              'Cilantro',
                              'TBS',
                            ].map((item) {
                              final selected =
                              item == 'All'
                                  ? brand.isEmpty
                                  : brand == item;

                              return ChoiceChip(
                                label: Text(item),
                                selected: selected,
                                selectedColor:
                                const Color(0xFFFFE4DF),
                                onSelected: (_) {
                                  setState(() {
                                    brand = item == 'All' ? '' : item;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                brand = '';
                                category = '';
                                searchQuery = '';
                                searchController.clear();
                              });
                            },
                            child: const Text(
                              'Clear filters',
                              style: TextStyle(color: orange),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _sortChip('Relevance'),
                        const SizedBox(width: 8),
                        _sortChip('Price ↑'),
                        const SizedBox(width: 8),
                        _sortChip('Price ↓'),
                        const SizedBox(width: 8),
                        _sortChip('A – Z'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  Text(
                    '${products.length} ${products.length == 1 ? 'item' : 'items'}',
                    style: const TextStyle(
                      color: Color(0xFF98A2B3),
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 16),

                  if (products.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 55,
                            color: Color(0xFF98A2B3),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'No products found',
                            style: TextStyle(
                              color: Color(0xFF98A2B3),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics:
                      const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 14,
                        mainAxisExtent: 268,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];

                        return _productCard(product);
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButton({
    required IconData icon,
    required VoidCallback onTap,
    bool showDot = false,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Stack(
            children: [
              Center(
                child: Icon(
                  icon,
                  size: 21,
                  color: const Color(0xFF475467),
                ),
              ),
              if (showDot)
                const Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    radius: 3,
                    backgroundColor: Color(0xFFFF6048),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sortChip(String label) {
    final selected = sortOption == label;

    return InkWell(
      onTap: () {
        setState(() {
          sortOption = label;
        });
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected ? orange : Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            if (!selected)
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : const Color(0xFF475467),
          ),
        ),
      ),
    );
  }

  Widget _productCard(Map<String, String> product) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Stack(
              children: [
                Image.network(
                  product['image']!,
                  width: double.infinity,
                  height: 128,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 128,
                      color: const Color(0xFFF0F0F0),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.local_cafe,
                        color: Colors.grey,
                        size: 40,
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 9,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.58),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product['brand']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            product['brand']!.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFFFF6048),
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: Text(
              product['name']!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                height: 1.2,
                fontWeight: FontWeight.w700,
                color: Color(0xFF19202D),
              ),
            ),
          ),
          Row(
            children: [
              Flexible(
                child: Text(
                  product['price']!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF19202D),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                'EGP',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF98A2B3),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 34,
                height: 34,
                child: Material(
                  color: orange,
                  borderRadius: BorderRadius.circular(9),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(9),
                    onTap: () => addProduct(product),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 23,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

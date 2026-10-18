import 'package:flutter/material.dart';
import 'package:otlob_app/screens/explore_screen.dart';
import '../widgets/offer_card.dart';
import '../widgets/category_item.dart';
import '../widgets/brand_item.dart';
import '../widgets/product_item.dart';
import '../widgets/bottom_nav_bar.dart';
import 'product_details_screen.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';
import 'restaurant_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedNavIndex = 0;
  int cartCount = 0;
  String selectedCategory = '';
  String selectedBrand = '';

  final TextEditingController searchController =
  TextEditingController();

  final List<Map<String, dynamic>> categories = [
    {'name': 'Frappuccino', 'icon': Icons.local_drink_outlined},
    {'name': 'Latte', 'icon': Icons.coffee_outlined},
    {'name': 'Mocha', 'icon': Icons.coffee},
    {'name': 'Macchiato', 'icon': Icons.local_cafe_outlined},
  ];

  final List<String> brands = [
    'Starbucks',
    'Costa',
    'Cilantro',
    'Dunkin',
  ];

  final List<Map<String, String>> products = [
    {
      'name': 'Double Caramel Frappuccino',
      'category': 'Frappuccino',
      'brand': 'Starbucks',
      'price': '200',
      'image': 'assets/images/2.png',
    },
    {
      'name': 'Blueberry Cheesecake',
      'category': 'Cake',
      'brand': 'Starbucks',
      'price': '155',
      'image': 'assets/images/1.png',
    },
    {
      'name': 'Caramel Latte',
      'category': 'Latte',
      'brand': 'Costa',
      'price': '135',
      'image': 'assets/images/2.png',
    },
    {
      'name': 'Chocolate Mocha',
      'category': 'Mocha',
      'brand': 'Cilantro',
      'price': '145',
      'image': 'assets/images/1.png',
    },
  ];

  final List<Map<String, String>> cartItems = [];

  void addToCart(Map<String, String> product) {
    setState(() {
      cartItems.add(Map<String, String>.from(product));
      cartCount = cartItems.length;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get filteredProducts {
    final query = searchController.text.trim().toLowerCase();

    return products.where((product) {
      final matchesSearch = query.isEmpty ||
          product['name']!.toLowerCase().contains(query) ||
          product['category']!.toLowerCase().contains(query) ||
          product['brand']!.toLowerCase().contains(query);

      final matchesCategory = selectedCategory.isEmpty ||
          product['category'] == selectedCategory;

      final matchesBrand = selectedBrand.isEmpty ||
          product['brand'] == selectedBrand;

      return matchesSearch && matchesCategory && matchesBrand;
    }).toList();
  }



  void removeFromCart(Map<String, String> product) {
    setState(() {
      final index = cartItems.indexWhere(
            (item) =>
        item['name'] == product['name'] &&
            item['brand'] == product['brand'],
      );

      if (index != -1) {
        cartItems.removeAt(index);
      }

      cartCount = cartItems.length;
    });
  }

  Widget sectionHeader(
      String title, {
        String? action,
        VoidCallback? onAction,
      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF191B24),
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              action,
              style: const TextStyle(
                color: Color(0xFFE87969),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget buildHomeContent() {
    final visibleProducts = filteredProducts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good evening ☕',
                    style: TextStyle(
                      color: Color(0xFF50515A),
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '7AMO',
                    style: TextStyle(
                      color: Color(0xFF191B24),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'serif',
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No new notifications'),
                  ),
                );
              },
              icon: const Icon(
                Icons.notifications_none,
                color: Color(0xFF252936),
              ),
            ),
          ],
        ),

        const SizedBox(height: 13),

        const Row(
          children: [
            Icon(
              Icons.location_on,
              color: Color(0xFFFF654F),
              size: 15,
            ),
            SizedBox(width: 5),
            Text(
              '14 Tahrir Square, Cairo',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF252936),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFFFF654F),
              size: 17,
            ),
          ],
        ),

        const SizedBox(height: 16),

        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.search,
                color: Color(0xFF9299A3),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Search coffee, cakes, donuts...',
                    hintStyle: TextStyle(
                      fontSize: 11,
                      color: Color(0xFFA1A6AE),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              if (searchController.text.isNotEmpty)
                IconButton(
                  onPressed: () {
                    searchController.clear();
                    setState(() {});
                  },
                  icon: const Icon(Icons.close, size: 17),
                )
              else
                const Icon(
                  Icons.filter_alt,
                  color: Color(0xFFFF654F),
                  size: 18,
                ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        OfferCard(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Use code BITE10 at checkout'),
              ),
            );
          },
        ),

        const SizedBox(height: 29),

        sectionHeader(
          'Categories',
          action: 'See all',
          onAction: () {
            setState(() {
              selectedCategory = '';
              selectedBrand = '';
            });
          },
        ),

        const SizedBox(height: 15),

        SizedBox(
          height: 95,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) =>
            const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final category = categories[index];
              final name = category['name'] as String;

              return CategoryItem(
                name: name,
                icon: category['icon'] as IconData,
                selected: selectedCategory == name,
                onTap: () {
                  setState(() {
                    selectedCategory =
                    selectedCategory == name ? '' : name;
                    selectedBrand = '';
                  });
                },
              );
            },
          ),
        ),

        const SizedBox(height: 26),

        sectionHeader(
          'Brands',
          action: selectedBrand.isNotEmpty ? 'Clear' : null,
          onAction: () {
            setState(() {
              selectedBrand = '';
            });
          },
        ),

        const SizedBox(height: 15),

        SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: brands.length,
            separatorBuilder: (_, __) =>
            const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final brand = brands[index];

              return BrandItem(
                name: brand,
                selected: selectedBrand == brand,
                onTap: () {
                  setState(() {
                    selectedBrand =
                    selectedBrand == brand ? '' : brand;
                    selectedCategory = '';
                  });
                },
              );
            },
          ),
        ),

        const SizedBox(height: 26),

        sectionHeader('Popular right now'),

        const SizedBox(height: 15),

        if (visibleProducts.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Text('No products found'),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: visibleProducts.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 14,
              childAspectRatio: 0.57,
            ),
            itemBuilder: (context, index) {
              final product = visibleProducts[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailsScreen(
                        product: product,
                        onAddToCart: () => addToCart(product),
                      ),
                    ),
                  );
                },
                child: ProductItem(
                  name: product['name']!,
                  category: product['category']!,
                  brand: product['brand']!,
                  price: product['price']!,
                  imagePath: product['image']!,
                  onAdd: () => addToCart(product),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget buildSelectedPage() {
    switch (selectedNavIndex) {
      case 0:
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(10, 12, 16, 12),
          child: buildHomeContent(),
        );

      case 1:
        return RestaurantExploreScreen(
          onAddToCart: addToCart,
        );

      case 2:
        return const ExploreScreen();

      case 3:
        return CartScreen(
          cartItems: cartItems,
          onAdd: addToCart,
          onRemove: removeFromCart,
        );

      case 4:
        return const OrdersScreen();

      case 5:
        return ProfileScreen(
          onOrders: () {
            setState(() {
              selectedNavIndex = 4;
            });
          },
        );

      default:
        return const SizedBox.shrink();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: buildSelectedPage(),
            ),
            BottomNavBar(
              selectedIndex: selectedNavIndex,
              cartCount: cartCount,
              onTap: (index) {
                setState(() {
                  selectedNavIndex = index;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

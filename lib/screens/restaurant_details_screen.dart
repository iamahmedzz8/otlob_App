import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'food_details_screen.dart';
import '../widgets/bottom_nav_bar.dart';

const Color restaurantRed = Color(0xFFFF654F);
const Color restaurantDarkRed = Color(0xFFBE2E12);
const Color restaurantBackground = Color(0xFFF7F7F5);
const Color restaurantText = Color(0xFF222222);

class RestaurantDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> restaurant;
  final Function(Map<String, String>)? onAddToCart;
  final int cartCount;
  final ValueChanged<int>? onNavTap;
  const RestaurantDetailsScreen({
    super.key,
    required this.restaurant,
    this.onAddToCart,
    this.cartCount = 0,
    this.onNavTap,
  });
  @override
  State<RestaurantDetailsScreen> createState() =>
      _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantDetailsScreen> {
  bool isFavorite = false;
  bool discountApplied = false;
  String selectedCategory = 'Popular';

  final List<String> categories = [
    'Popular',
    'Burgers',
    'Meals',
    'Chicken',
  ];

  // المنتجات الافتراضية لمطعم Burger House
  final List<Map<String, String>> defaultProducts = [
    {
      'name': 'Truffle Smash Burger',
      'description':
      'Double angus patty, black truffle aioli, aged swiss cheese.',
      'price': '180',
      'category': 'Burgers',
      'image':
      'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600',
    },
    {
      'name': 'Smoky Bacon BBQ Burger',
      'description': 'Crispy bacon, cheddar cheese, smoky bbq sauce.',
      'price': '165',
      'category': 'Burgers',
      'image':
      'https://images.unsplash.com/photo-1553979459-d2229ba7433a?w=600',
    },
    {
      'name': 'Truffle Parmesan Fries',
      'description':
      'Crispy hand-cut fries tossed in white truffle oil and parmesan.',
      'price': '75',
      'category': 'Meals',
      'image':
      'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=600',
    },
    {
      'name': 'Salted Caramel Milkshake',
      'description':
      'Rich vanilla bean ice cream blended with house caramel.',
      'price': '60',
      'category': 'Meals',
      'image':
      'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=600',
    },
    {
      'name': 'Crispy Chicken Burger',
      'description':
      'Crispy chicken, fresh lettuce and signature sauce.',
      'price': '145',
      'category': 'Chicken',
      'image':
      'https://images.unsplash.com/photo-1606755962773-d324e0a13086?w=600',
    },
    {
      'name': 'Chicken Strips Meal',
      'description':
      'Golden chicken strips served with crispy fries.',
      'price': '155',
      'category': 'Chicken',
      'image':
      'https://images.unsplash.com/photo-1562967914-608f82629710?w=600',
    },
  ];

  String get restaurantName =>
      widget.restaurant['name']?.toString() ?? 'Restaurant';

  String get restaurantImage =>
      widget.restaurant['image']?.toString() ?? '';

  String get restaurantRating =>
      widget.restaurant['rating']?.toString() ?? '4.8';

  String get restaurantReviews =>
      widget.restaurant['reviews']?.toString() ?? '500+';

  String get restaurantType =>
      widget.restaurant['type']?.toString() ?? 'Restaurant';

  String get deliveryTime =>
      widget.restaurant['time']?.toString() ?? '20-30 min';

  String get deliveryFee =>
      widget.restaurant['delivery']?.toString() ?? 'EGP 15 delivery';

  String get restaurantDescription =>
      widget.restaurant['description']?.toString() ??
          'Enjoy delicious food freshly prepared with quality ingredients.';

  // اقرأ المنتجات من المطعم المختار
  List<Map<String, String>> get products {
    final restaurantProducts = widget.restaurant['products'];

    if (restaurantProducts is List) {
      return restaurantProducts
          .whereType<Map>()
          .map(
            (item) => item.map(
              (key, value) => MapEntry(
            key.toString(),
            value.toString(),
          ),
        ),
      )
          .toList();
    }

    // لو المطعم مفيهوش products، استخدم القائمة الافتراضية
    return defaultProducts;
  }

  List<Map<String, String>> get filteredProducts {
    if (selectedCategory == 'Popular') {
      return products.take(4).toList();
    }

    return products
        .where(
          (product) => product['category'] == selectedCategory,
    )
        .toList();
  }

  void addProduct(Map<String, String> product) {
    widget.onAddToCart?.call(product);
  }
  void openFoodDetails(Map<String, String> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FoodDetailsScreen(
          product: product,
          restaurantName: restaurantName,
          onAddToCart: widget.onAddToCart,
          cartCount: widget.cartCount,
          onNavTap: widget.onNavTap,
        ),
      ),
    );
  }  Future<void> shareRestaurant() async {
    await Clipboard.setData(
      ClipboardData(
        text: '$restaurantName - Restaurant Details',
      ),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Restaurant details copied'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleProducts = filteredProducts;

    return Scaffold(
      backgroundColor: restaurantBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 12),
                    _buildCover(),
                    const SizedBox(height: 16),
                    _buildRestaurantInfo(),
                    const SizedBox(height: 16),
                    _buildCategories(),
                    const SizedBox(height: 24),
                    _buildPopularHeader(visibleProducts.length),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            if (visibleProducts.isEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Center(
                    child: Text('No products in this category'),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildProductCard(
                          visibleProducts[index],
                        ),
                      );
                    },
                    childCount: visibleProducts.length,
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: widget.onNavTap == null
          ? null
          : BottomNavBar(
        selectedIndex: 1,
        cartCount: widget.cartCount,
        onTap: widget.onNavTap!,
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(
              Icons.arrow_back,
              size: 26,
              color: restaurantText,
            ),
          ),
          const SizedBox(width: 6),
          const Expanded(
            child: Text(
              'Restaurant Details',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: restaurantText,
              ),
            ),
          ),
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: restaurantDarkRed,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile')),
                );
              },
              icon: const Icon(
                Icons.person_outline,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCover() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(19),
      child: SizedBox(
        width: double.infinity,
        height: 220,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (restaurantImage.isNotEmpty)
              Image.network(
                restaurantImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _imagePlaceholder(Icons.restaurant);
                },
              )
            else
              _imagePlaceholder(Icons.restaurant),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black26,
                    Colors.transparent,
                    Colors.black26,
                  ],
                ),
              ),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: _roundButton(
                icon: Icons.arrow_back,
                onTap: () => Navigator.maybePop(context),
              ),
            ),
            Positioned(
              top: 12,
              right: 62,
              child: _roundButton(
                icon: isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: restaurantDarkRed,
                onTap: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: _roundButton(
                icon: Icons.share_outlined,
                onTap: shareRestaurant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundButton({
    required IconData icon,
    required VoidCallback onTap,
    Color color = restaurantText,
  }) {
    return Material(
      color: Colors.white.withValues(alpha: 0.94),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 43,
          height: 43,
          child: Icon(icon, color: color, size: 23),
        ),
      ),
    );
  }

  Widget _buildRestaurantInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F3E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.storefront_outlined,
                  color: restaurantDarkRed,
                  size: 33,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurantName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                        color: restaurantText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 4,
                      children: [
                        const Icon(
                          Icons.star,
                          size: 15,
                          color: restaurantRed,
                        ),
                        Text(
                          '$restaurantRating ($restaurantReviews)',
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          '• $restaurantType',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _infoChip(Icons.access_time, deliveryTime),
              _infoChip(Icons.delivery_dining, deliveryFee),
              _infoChip(
                Icons.shopping_bag_outlined,
                'Min. EGP ${widget.restaurant['minimum'] ?? '50'}',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F4F2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.circle,
                  size: 9,
                  color: restaurantRed,
                ),
                SizedBox(width: 7),
                Text(
                  'Open until 12:00 AM',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            restaurantDescription,
            style: const TextStyle(
              fontSize: 15,
              height: 1.55,
              color: Color(0xFF696969),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1EE),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: restaurantRed,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(
                    Icons.local_offer_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Use code BITE10',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        '10% off your entire order',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      discountApplied = !discountApplied;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          discountApplied
                              ? 'BITE10 applied!'
                              : 'Discount removed',
                        ),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: restaurantDarkRed,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 9,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    discountApplied ? 'Applied' : 'Apply',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Colors.grey.shade700),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = selectedCategory == category;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 17),
              decoration: BoxDecoration(
                color: selected ? restaurantDarkRed : Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : restaurantText,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPopularHeader(int count) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Popular Items',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: restaurantText,
            ),
          ),
        ),
        Text(
          '$count curated dishes',
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF777777),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(Map<String, String> product) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => openFoodDetails(product),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'] ?? 'Food item',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: restaurantText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product['description'] ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: Color(0xFF777777),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'EGP ${product['price'] ?? '0'}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: restaurantText,
                            ),
                          ),
                        ),
                        Material(
                          color: restaurantRed,
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () => addProduct(product),
                            child: const SizedBox(
                              width: 29,
                              height: 29,
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 76,
                  height: 84,
                  child: Image.network(
                    product['image'] ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _imagePlaceholder(Icons.fastfood);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imagePlaceholder(IconData icon) {
    return Container(
      color: const Color(0xFFF0E9E3),
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: 38,
        color: restaurantDarkRed,
      ),
    );
  }
}

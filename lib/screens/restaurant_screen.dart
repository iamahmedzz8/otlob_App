import 'package:flutter/material.dart';
import 'package:otlob_app/screens/profile_screen.dart';
import 'package:otlob_app/screens/restaurant_details_screen.dart';
import 'restaurant_details_screen.dart';
import 'restaurant_details_screen.dart';
const Color exploreRed = Color(0xFFFF654F);
const Color exploreText = Color(0xFF222222);
const Color exploreBackground = Color(0xFFF8F8F6);

class RestaurantExploreScreen extends StatefulWidget {
  final Function(Map<String, String>)? onAddToCart;
  final int cartCount;
  final ValueChanged<int>? onNavTap;
  const RestaurantExploreScreen({
    super.key,
    this.onAddToCart,
    this.cartCount = 0,
    this.onNavTap,
  });

  @override
  State<RestaurantExploreScreen> createState() =>
      _RestaurantExploreScreenState();
}
class _RestaurantExploreScreenState
    extends State<RestaurantExploreScreen> {
  final TextEditingController searchController =
  TextEditingController();

  String selectedFilter = 'All';
  String selectedSort = 'Recommended';

  final Set<String> favorites = {};

  final List<Map<String, dynamic>> restaurants = [
    {
      'name': 'Burger House',
      'rating': '4.8',
      'reviews': '500+',
      'type': 'American • Gourmet Burgers • Wings',
      'delivery': 'EGP 15 delivery',
      'distance': '1.8 km away',
      'time': '20-30 min',
      'offer': '20% OFF up to EGP 50',
      'image':
      'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=900',
      'category': 'Burgers',
      'fast': true,
      'discount': true,
    },
    {
      'name': "Luigi's Oven",
      'rating': '4.9',
      'reviews': '1.2k',
      'type': 'Italian • Pizza • Pasta • Artisanal',
      'delivery': 'Free delivery',
      'distance': '2.4 km away',
      'time': '25-35 min',
      'offer': 'Buy 1 Get 1 Free',
      'image':
      'https://images.unsplash.com/photo-1579751626657-72bc17010498?w=900',
      'category': 'Pizza',
      'fast': true,
      'discount': true,
    },
    {
      'name': 'Sakura House',
      'rating': '4.7',
      'reviews': '350',
      'type': 'Japanese • Sushi • Asian Fusion',
      'delivery': 'EGP 20 delivery',
      'distance': '3.1 km away',
      'time': '30-45 min',
      'offer': '',
      'image':
      'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=900',
      'category': 'Sushi',
      'fast': false,
      'discount': false,
    },
    {
      'name': 'Green Roots',
      'rating': '4.6',
      'reviews': '420',
      'type': 'Healthy • Vegan • Organic Bowls',
      'delivery': 'Free Delivery',
      'distance': '0.9 km away',
      'time': '15-25 min',
      'offer': 'Free Delivery',
      'image':
      'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=900',
      'category': 'Healthy',
      'fast': true,
      'discount': false,
    },
  ];

  List<Map<String, dynamic>> get filteredRestaurants {
    final query = searchController.text.trim().toLowerCase();

    List<Map<String, dynamic>> result =
    restaurants.where((restaurant) {
      final matchesSearch =
          restaurant['name'].toString().toLowerCase().contains(query) ||
              restaurant['type'].toString().toLowerCase().contains(query);

      final matchesFilter = switch (selectedFilter) {
        'Open Now' => true,
        'Fast Delivery' => restaurant['fast'] == true,
        'Offers' => restaurant['discount'] == true,
        _ => true,
      };

      return matchesSearch && matchesFilter;
    }).toList();

    if (selectedSort == 'Rating') {
      result.sort(
            (a, b) => (double.parse(b['rating']))
            .compareTo(double.parse(a['rating'])),
      );
    } else if (selectedSort == 'Delivery Time') {
      result.sort((a, b) {
        int minutes(Map<String, dynamic> item) =>
            int.parse(item['time'].split('-')[0]);
        return minutes(a).compareTo(minutes(b));
      });
    }

    return result;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleRestaurants = filteredRestaurants;

    return Scaffold(
      backgroundColor: exploreBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: CustomScrollView(
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildTitle(),
                        const SizedBox(height: 18),
                        _buildSearch(),
                        const SizedBox(height: 16),
                        _buildFilters(),
                        const SizedBox(height: 20),
                        _buildResultsHeader(visibleRestaurants.length),
                        const SizedBox(height: 14),
                      ]),
                    ),
                  ),
                  if (visibleRestaurants.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          'No restaurants found',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
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
                              padding:
                              const EdgeInsets.only(bottom: 14),
                              child: _buildRestaurantCard(
                                visibleRestaurants[index],
                              ),
                            );
                          },
                          childCount: visibleRestaurants.length,
                        ),
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 6),
      child: Row(
        children: [
          const Icon(
            Icons.restaurant_menu_rounded,
            color: exploreRed,
            size: 24,
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Explore',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: exploreText,
              ),
            ),
          ),
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: Color(0xFFBE2E12),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile')),
                );
              },
              padding: EdgeInsets.zero,
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

  Widget _buildTitle() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Color(0xFFF0F0EE),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.location_on_outlined,
            size: 21,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Discover Near You',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                'Restaurants',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  color: exploreText,
                ),
              ),
            ],
          ),
        ),
        _smallCircleButton(
          Icons.map_outlined,
              () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Map view coming soon')),
            );
          },
        ),
        const SizedBox(width: 8),
        _smallCircleButton(
          Icons.tune_rounded,
          _showSortOptions,
        ),
      ],
    );
  }

  Widget _smallCircleButton(
      IconData icon,
      VoidCallback onTap,
      ) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 21),
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      height: 49,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            size: 22,
            color: Colors.grey,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'Search restaurants or dishes',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          const Icon(
            Icons.mic_none_rounded,
            color: Colors.grey,
            size: 22,
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    const filters = [
      'All',
      'Open Now',
      'Fast Delivery',
      'Offers',
    ];

    return SizedBox(
      height: 37,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final selected = selectedFilter == filter;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedFilter = filter;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: selected ? exploreRed : Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : exploreText,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultsHeader(int count) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$count CURATED SPOTS',
            style: const TextStyle(
              fontSize: 11,
              letterSpacing: 0.4,
              fontWeight: FontWeight.w600,
              color: Color(0xFF626262),
            ),
          ),
        ),
        GestureDetector(
          onTap: _showSortOptions,
          child: Row(
            children: [
              Text(
                'Sort by: $selectedSort',
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFFBE2E12),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: Color(0xFFBE2E12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(18),
                child: Text(
                  'Sort Restaurants',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...['Recommended', 'Rating', 'Delivery Time'].map(
                    (sort) => ListTile(
                  title: Text(sort),
                  trailing: selectedSort == sort
                      ? const Icon(
                    Icons.check,
                    color: exploreRed,
                  )
                      : null,
                  onTap: () {
                    setState(() {
                      selectedSort = sort;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRestaurantCard(
      Map<String, dynamic> restaurant,
      ) {
    final name = restaurant['name'] as String;
    final isFav = favorites.contains(name);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RestaurantDetailsScreen(
                restaurant: restaurant,
                onAddToCart: widget.onAddToCart,
                cartCount: widget.cartCount,
                onNavTap: widget.onNavTap,
              ),
            ),
          );        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 137,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        restaurant['image'] as String,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFFE9E2DB),
                            child: const Icon(
                              Icons.restaurant,
                              size: 45,
                              color: exploreRed,
                            ),
                          );
                        },
                      ),
                      if ((restaurant['offer'] as String).isNotEmpty)
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFBE2E12),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              restaurant['offer'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        top: 9,
                        right: 9,
                        child: Material(
                          color: Colors.white.withValues(alpha: 0.95),
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () {
                              setState(() {
                                if (isFav) {
                                  favorites.remove(name);
                                } else {
                                  favorites.add(name);
                                }
                              });
                            },
                            child: SizedBox(
                              width: 34,
                              height: 34,
                              child: Icon(
                                isFav
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 21,
                                color: isFav ? exploreRed : exploreText,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 9,
                        left: 9,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.96),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: exploreRed,
                                size: 13,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                restaurant['time'] as String,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: exploreText,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0EE),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 13,
                          color: exploreRed,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${restaurant['rating']} (${restaurant['reviews']})',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Text(
                restaurant['type'] as String,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF777777),
                ),
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Icon(
                    Icons.delivery_dining,
                    size: 14,
                    color: restaurant['delivery'] == 'Free delivery' ||
                        restaurant['delivery'] == 'Free Delivery'
                        ? const Color(0xFFBE2E12)
                        : Colors.grey.shade700,
                  ),
                  const SizedBox(width: 3),
                  Flexible(
                    child: Text(
                      restaurant['delivery'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: restaurant['delivery'] == 'Free delivery' ||
                            restaurant['delivery'] == 'Free Delivery'
                            ? const Color(0xFFBE2E12)
                            : exploreText,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    '·',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    restaurant['distance'] as String,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
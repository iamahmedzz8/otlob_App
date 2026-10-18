import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/bottom_nav_bar.dart';

const Color foodRed = Color(0xFFFF654F);
const Color foodDarkRed = Color(0xFFBE2E12);
const Color foodBackground = Color(0xFFF8F8F6);
const Color foodText = Color(0xFF222222);

class FoodDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  final String restaurantName;
  final int cartCount;
  final ValueChanged<int>? onNavTap;
  final Function(Map<String, String>)? onAddToCart;

  const FoodDetailsScreen({
    super.key,
    required this.product,
    this.restaurantName = 'Burger House',
    this.cartCount = 0,
    this.onNavTap,
    this.onAddToCart,
  });

  @override
  State<FoodDetailsScreen> createState() =>
      _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  bool isFavorite = false;

  String selectedSpice = 'Mild';
  String selectedSize = 'Double Patty';

  final TextEditingController instructionsController =
  TextEditingController();

  final Map<String, int> spicePrices = {
    'Mild': 0,
    'Regular': 0,
    'Spicy': 5,
    'Extra Spicy': 10,
  };

  final Map<String, int> sizePrices = {
    'Single Patty': -30,
    'Double Patty': 0,
    'Triple Patty': 55,
  };

  final Map<String, String> spiceEmojis = {
    'Mild': '',
    'Regular': '',
    'Spicy': ' 🌶️',
    'Extra Spicy': ' 🔥🔥',
  };

  double get basePrice {
    final value = widget.product['price'];
    if (value is num) return value.toDouble();

    return double.tryParse(value?.toString() ?? '') ?? 180;
  }

  double get finalPrice {
    return basePrice +
        (spicePrices[selectedSpice] ?? 0) +
        (sizePrices[selectedSize] ?? 0);
  }

  String get productName =>
      widget.product['name']?.toString() ?? 'Double Truffle Smash Burger';

  String get productImage =>
      widget.product['image']?.toString() ?? '';

  String get productDescription =>
      widget.product['description']?.toString() ??
          'Two fresh 100% grass-fed Angus beef patties smashed crispy, '
              'melted aged Swiss cheese, sautéed wild mushrooms, and '
              'house-made black truffle aioli on a toasted artisanal brioche bun.';

  String get productRating =>
      widget.product['rating']?.toString() ?? '4.9';

  @override
  void dispose() {
    instructionsController.dispose();
    super.dispose();
  }

  void addToCart() {
    final Map<String, String> cartProduct = {
      'name': widget.product['name']?.toString() ?? '',
      'description': widget.product['description']?.toString() ?? '',
      'image': widget.product['image']?.toString() ?? '',
      'price': finalPrice.toString(),
      'restaurant': widget.restaurantName,
      'spice': selectedSpice,
      'size': selectedSize,
      'instructions': instructionsController.text,
    };

    if (widget.onAddToCart != null) {
      widget.onAddToCart!(cartProduct);
      return;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: foodBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProductImage(),
                    const SizedBox(height: 14),
                    _buildProductInformation(),
                    const SizedBox(height: 20),
                    _buildSpiceSelector(),
                    const SizedBox(height: 16),
                    _buildSizeSelector(),
                    const SizedBox(height: 16),
                    _buildInstructions(),
                    const SizedBox(height: 20),
                    _buildAddButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: widget.onNavTap == null
          ? null
          : BottomNavBar(
        selectedIndex: 2,
        cartCount: widget.cartCount,
        onTap: (index) {
          Navigator.of(context).popUntil(
                (route) => route.isFirst,
          );
          widget.onNavTap!(index);
        },
      ),
    );
  }


  Widget _buildHeader() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back, size: 23),
          ),
          const Expanded(
            child: Text(
              'Food Details',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: foodText,
              ),
            ),
          ),
          Container(
            width: 35,
            height: 35,
            decoration: const BoxDecoration(
              color: foodDarkRed,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: const Icon(
                Icons.person_outline,
                color: Colors.white,
                size: 21,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        width: double.infinity,
        height: 205,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (productImage.isNotEmpty)
              Image.network(
                productImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _imagePlaceholder(),
              )
            else
              _imagePlaceholder(),

            Positioned(
              top: 12,
              left: 12,
              child: _imageButton(
                icon: Icons.arrow_back,
                onTap: () => Navigator.maybePop(context),
              ),
            ),

            Positioned(
              top: 12,
              right: 12,
              child: _imageButton(
                icon: isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: foodDarkRed,
                onTap: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
              ),
            ),

            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.65),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 13,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Chef's Signature",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageButton({
    required IconData icon,
    required VoidCallback onTap,
    Color color = foodText,
  }) {
    return Material(
      color: Colors.white.withValues(alpha: 0.95),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 39,
          height: 39,
          child: Icon(icon, color: color, size: 22),
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: const Color(0xFFEDE8E2),
      alignment: Alignment.center,
      child: const Icon(
        Icons.fastfood,
        color: foodDarkRed,
        size: 55,
      ),
    );
  }

  Widget _buildProductInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          productName,
          style: const TextStyle(
            fontSize: 25,
            height: 1.15,
            fontWeight: FontWeight.w800,
            color: foodText,
          ),
        ),
        const SizedBox(height: 9),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 7,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE4DE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star,
                    color: foodDarkRed,
                    size: 13,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    productRating,
                    style: const TextStyle(
                      fontSize: 11,
                      color: foodDarkRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              '(340 reviews)',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
            const Text(
              '•',
              style: TextStyle(color: Colors.grey),
            ),
            Text(
              widget.restaurantName,
              style: const TextStyle(
                fontSize: 11,
                color: foodDarkRed,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          children: [
            Text(
              'EGP ${finalPrice.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: foodRed,
              ),
            ),
            Text(
              'EGP ${(basePrice + 30).toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          productDescription,
          style: const TextStyle(
            fontSize: 12,
            height: 1.55,
            color: Color(0xFF707070),
          ),
        ),
      ],
    );
  }

  Widget _buildSpiceSelector() {
    return _optionSection(
      title: 'Choose your spice level',
      subtitle: 'Customized heat profile',
      badge: 'Pick 1',
      children: [
        _optionTile(
          title: 'Mild (Standard)',
          trailing: '+EGP 0',
          value: 'Mild',
          group: selectedSpice,
          onChanged: (value) {
            setState(() => selectedSpice = value);
          },
        ),
        _optionTile(
          title: 'Regular',
          trailing: '+EGP 0',
          value: 'Regular',
          group: selectedSpice,
          onChanged: (value) {
            setState(() => selectedSpice = value);
          },
        ),
        _optionTile(
          title: 'Spicy 🌶️',
          trailing: '+EGP 5',
          value: 'Spicy',
          group: selectedSpice,
          onChanged: (value) {
            setState(() => selectedSpice = value);
          },
        ),
        _optionTile(
          title: 'Extra Spicy 🔥🔥',
          trailing: '+EGP 10',
          value: 'Extra Spicy',
          group: selectedSpice,
          onChanged: (value) {
            setState(() => selectedSpice = value);
          },
        ),
      ],
    );
  }

  Widget _buildSizeSelector() {
    return _optionSection(
      title: 'Choose your size',
      subtitle: 'Portion selection',
      badge: 'Required',
      children: [
        _optionTile(
          title: 'Single Patty',
          trailing: '-EGP 30',
          value: 'Single Patty',
          group: selectedSize,
          onChanged: (value) {
            setState(() => selectedSize = value);
          },
        ),
        _optionTile(
          title: 'Double Patty (Original)',
          trailing: 'Included',
          value: 'Double Patty',
          group: selectedSize,
          onChanged: (value) {
            setState(() => selectedSize = value);
          },
        ),
        _optionTile(
          title: 'Triple Patty Beast',
          trailing: '+EGP 55',
          value: 'Triple Patty',
          group: selectedSize,
          onChanged: (value) {
            setState(() => selectedSize = value);
          },
        ),
      ],
    );
  }

  Widget _optionSection({
    required String title,
    required String subtitle,
    required String badge,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1EF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: foodText,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: foodDarkRed,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _optionTile({
    required String title,
    required String trailing,
    required String value,
    required String group,
    required ValueChanged<String> onChanged,
  }) {
    final selected = value == group;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.symmetric(
          horizontal: 9,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? const Color(0xFFFFD4CA)
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? foodRed : Colors.grey,
                  width: 1,
                ),
              ),
              child: selected
                  ? Center(
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: foodRed,
                  ),
                ),
              )
                  : null,
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  color: foodText,
                ),
              ),
            ),
            Text(
              trailing,
              style: TextStyle(
                fontSize: 10,
                color: trailing.startsWith('+EGP') &&
                    trailing != '+EGP 0'
                    ? foodRed
                    : Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1EF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Special instructions',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: foodText,
                  ),
                ),
              ),
              Text(
                'Freeform',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: instructionsController,
            maxLines: 4,
            maxLength: 200,
            decoration: InputDecoration(
              hintText:
              'e.g. No onions, sauce on the side, extra crispy edges...',
              hintStyle: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
                height: 1.5,
              ),
              counterText: '',
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 8),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                size: 13,
                color: Colors.grey,
              ),
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  'Kitchen will do its absolute best to accommodate your preferences.',
                  style: TextStyle(
                    fontSize: 10,
                    height: 1.4,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      width: double.infinity,
      height: 49,
      child: ElevatedButton(
        onPressed: addToCart,
        style: ElevatedButton.styleFrom(
          backgroundColor: foodDarkRed,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          'Add to Cart • EGP ${finalPrice.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

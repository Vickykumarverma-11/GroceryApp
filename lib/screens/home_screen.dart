import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/location_provider.dart';
import 'product_details_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Get location when screen loads
    Future.microtask(() => Provider.of<LocationProvider>(context, listen: false)
        .getCurrentLocation());
    _filteredProducts = List.from(products);
    _searchController.addListener(_filterProducts);
  }

  final List<Product> products = [
    Product(
      id: '1',
      name: 'Apples',
      imageUrl: 'assets/apple.png',
      quantity: '4pcs',
      price: 8.99,
    ),
    Product(
      id: '2',
      name: 'Bananas',
      imageUrl: 'assets/banana.png',
      quantity: '5000g',
      price: 4.50,
    ),
    Product(
      id: '3',
      name: 'Palm',
      imageUrl: 'assets/palam.png',
      quantity: '400gm',
      price: 5.99,
    ),
    Product(
      id: '4',
      name: 'Papaya',
      imageUrl: 'assets/papaya.png',
      quantity: '1kg',
      price: 5.99,
    ),
    Product(
      id: '5',
      name: 'Stawberry',
      imageUrl: 'assets/stawberry.png',
      quantity: '4pcs',
      price: 4.99,
    ),
    Product(
      id: '6',
      name: 'Cauliflower',
      imageUrl: 'assets/cauli.png',
      quantity: '500g',
      price: 1.50,
    ),
    Product(
      id: '7',
      name: 'Drum Stick',
      imageUrl: 'assets/drum.png',
      quantity: '500gm',
      price: 9.99,
    ),
    Product(
      id: '8',
      name: 'Lady Finger',
      imageUrl: 'assets/ladufin.png',
      quantity: '500G',
      price: 5.99,
    ),
    Product(
      id: '9',
      name: 'Fortune Oil',
      imageUrl: 'assets/oil.png',
      quantity: '1L',
      price: 9.00,
    ),
    Product(
      id: '10',
      name: 'Rice',
      imageUrl: 'assets/rice.png',
      quantity: '5kg',
      price: 3.00,
    ),
    Product(
      id: '11',
      name: 'Atta',
      imageUrl: 'assets/atta.png',
      quantity: '1L',
      price: 5.00,
    ),
    Product(
      id: '12',
      name: 'Refine',
      imageUrl: 'assets/shopping.png',
      quantity: '1L',
      price: 9.00,
    ),
  ];

  final TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = products
          .where((product) => product.name.toLowerCase().contains(query))
          .toList();
    });
  }

  void _addToCart(Product product) {
    Provider.of<CartProvider>(context, listen: false).addItem(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'VIEW CART',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CartScreen(),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Consumer<LocationProvider>(
          builder: (context, location, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Grocery App',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!location.loading && location.error.isEmpty)
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFF53B175),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        location.locality.isNotEmpty && location.city.isNotEmpty
                            ? '${location.locality}, ${location.city}'
                            : 'Location not available',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
              ],
            );
          },
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartScreen(),
                    ),
                  );
                },
              ),
              Consumer<CartProvider>(
                builder: (ctx, cart, _) {
                  final totalItems = cart.items.values
                      .fold(0, (sum, item) => sum + item.quantity);
                  return totalItems > 0
                      ? Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '$totalItems',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : const SizedBox();
                },
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: const Icon(Icons.tune),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(
                            product: product,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Center(
                                child: Image.asset(
                                  product.imageUrl,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              product.quantity,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\u20b9${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Consumer<CartProvider>(
                                  builder: (ctx, cart, _) {
                                    final quantity =
                                        cart.items[product.id]?.quantity ?? 0;
                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (quantity > 0) ...[
                                          SizedBox(
                                            width: 32,
                                            height: 32,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.grey[200],
                                              child: IconButton(
                                                padding: EdgeInsets.zero,
                                                icon: const Icon(
                                                  Icons.remove,
                                                  color: Colors.grey,
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  Provider.of<CartProvider>(
                                                          context,
                                                          listen: false)
                                                      .updateQuantity(
                                                          product.id,
                                                          quantity - 1);
                                                },
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              '$quantity',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                        SizedBox(
                                          width: 32,
                                          height: 32,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                const Color(0xFF53B175),
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              icon: Center(
                                                child: const Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                              onPressed: () =>
                                                  _addToCart(product),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

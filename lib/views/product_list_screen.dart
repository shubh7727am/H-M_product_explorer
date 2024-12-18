import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/theme_provider.dart';
import '../view_models/product_notifier.dart';
import 'widgets/product_tile.dart';

// Main screen to display a list of products with infinite scrolling functionality
class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ProductListScreenState createState() => ProductListScreenState();
}

class ProductListScreenState extends ConsumerState<ProductListScreen> {
  late ScrollController _scrollController; // Controller to track scroll position
  int _currentPage = 0; // Current page for pagination
  bool _isFetching = false; // Flag to prevent duplicate fetches
  bool _hasMoreItems = true; // Indicates if there are more items to fetch

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(); // Initialize the scroll controller
    _scrollController.addListener(_onScroll); // Add a listener for scroll events
  }

  // Triggered when the user scrolls
  void _onScroll() {
    // Check if we're near the bottom of the list and not currently fetching data
    if (!_isFetching &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
      _fetchMoreProducts(); // Fetch the next batch of products
    }
  }

  // Fetch more products from the backend
  Future<void> _fetchMoreProducts() async {
    if (!_hasMoreItems) return; // Stop fetching if no more items are available

    setState(() {
      _isFetching = true; // Set fetching flag to true
    });

    try {
      _currentPage++; // Increment the page number
      // Fetch products using the notifier
      await ref
          .read(productNotifierProvider.notifier)
          .fetchMoreProducts(_currentPage);
    } catch (e) {
      // If no more items are available, update the state
      if (e.toString() == 'No more items found') {
        setState(() {
          _hasMoreItems = false;
        });
      }
    } finally {
      setState(() {
        _isFetching = false; // Reset the fetching flag
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose the scroll controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productNotifierProvider); // Watch the product state
    final themeMode = ref.watch(themeProvider); // Watch the theme mode

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0, // Remove shadow under the app bar
        title: const Text('Product List'), // Title of the screen
        elevation: 0,
        actions: [
          IconButton(
            // Theme toggle button
            icon: Icon(themeMode == ThemeMode.dark ? Icons.wb_sunny : Icons.nights_stay),
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme(); // Toggle theme
            },
          ),
        ],
      ),
      body: productState.when(
        data: (products) {
          // Display when data is available
          if (products.isEmpty) {
            return const Center(
              child: Text(
                '⚠️ No products found', // Message when no products are found
                style: TextStyle(fontSize: 24, color: Colors.grey),
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              // Adjust grid layout based on screen size
              int crossAxisCount = 2; // Default to 2 columns
              if (constraints.maxWidth > 600) crossAxisCount = 3; // Larger screens: 3 columns
              if (constraints.maxWidth > 900) crossAxisCount = 4; // Even larger screens: 4 columns

              return GridView.builder(
                controller: _scrollController, // Attach the scroll controller
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount, // Set the number of columns
                  crossAxisSpacing: 20.0, // Spacing between columns
                  mainAxisSpacing: 40.0, // Spacing between rows
                ),
                itemCount: products.length + (_hasMoreItems || _isFetching ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= products.length) {
                    // Footer: Show loading spinner or "No more items" message
                    if (!_hasMoreItems) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'No more items found', // End of list message
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      );
                    }
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(), // Loading spinner
                      ),
                    );
                  }

                  final product = products[index]; // Fetch product at the current index
                  return ProductTile(product: product); // Display the product
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()), // Show loader while data is loading
        error: (error, stack) {
          // Display error message
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: $error', style: TextStyle(color: Colors.red)),
                Text('Stack trace: $stack'), // Show stack trace for debugging
              ],
            ),
          );
        },
      ),
    );
  }
}

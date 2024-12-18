import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_models/product_notifier.dart';
import 'widgets/product_tile.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  late ScrollController _scrollController;
  int _currentPage = 0;
  bool _isFetching = false; // Prevent duplicate fetches

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Fetch the initial page
    ref.read(productNotifierProvider.notifier).fetchProducts(_currentPage);
  }

  void _onScroll() {
    // Trigger fetch when approaching the bottom
    if (!_isFetching &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent -
                _scrollController.position.viewportDimension) {
      _isFetching = true;
      _currentPage++;
      ref
          .read(productNotifierProvider.notifier)
          .fetchProducts(_currentPage)
          .then((_) => _isFetching = false)
          .catchError((_) => _isFetching = false); // Reset fetching state on error
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text('Product List'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: productState.when(
        data: (products) {
          return LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 2;
              if (constraints.maxWidth > 600) crossAxisCount = 3;
              if (constraints.maxWidth > 900) crossAxisCount = 4;

              return GridView.builder(
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 40.0,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductTile(product: product);
                },
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (error == 'No more items found')
                Text('No more items found', style: TextStyle(color: Colors.grey)),
              Text('Error: $error'),
              Text('Stack trace: $stack'),
            ],
          );
        },
      )
    );
  }
}

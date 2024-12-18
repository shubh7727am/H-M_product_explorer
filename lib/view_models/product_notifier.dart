import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hm_productexplorer/view_models/tagCodes_notifier.dart';
import '../models/product.dart';

import '../services/product_service..dart';
import 'category_notifier.dart';

final productNotifierProvider = StateNotifierProvider<ProductNotifier, AsyncValue<List<Product>>>((ref) {
  return ProductNotifier(ref.read(productServiceProvider), ref.read(cateGoryNotifierProvider.notifier), ref.read(selectedCateProvider.notifier));
});

class ProductNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  final ProductService _productService;
  final CategoryNotifier _categoryNotifier;
  final SelectedCateNotifier _selectedCateNotifier;

  // To keep track of the last fetched tag codes
  List<dynamic> _lastFetchedTagCodes = [];

  ProductNotifier(this._productService, this._categoryNotifier, this._selectedCateNotifier)
      : super(const AsyncValue.loading()) {
    _fetchInitialProducts(0); // Fetch initial products when notifier is created
  }

  Future<void> _fetchInitialProducts(int page) async {
    state = const AsyncValue.loading();
    await _initializeIfNeeded();
    try {
      final newProducts = await _productService.fetchProducts(page, _selectedCateNotifier.state.tagCodes);
      state = AsyncValue.data(newProducts); // Set initial products directly
      _lastFetchedTagCodes = _selectedCateNotifier.state.tagCodes;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> fetchMoreProducts(int page) async {
    await _initializeIfNeeded();

    if (_lastFetchedTagCodes != _selectedCateNotifier.state.tagCodes) {
      // If the tag codes have changed, fetch initial products again
      await _fetchInitialProducts(0);
      return;
    }

    try {
      final newProducts = await _productService.fetchProducts(page, _selectedCateNotifier.state.tagCodes);

      state = state.when(
        data: (existingProducts) {
          // Combine and deduplicate existing and new products
          final uniqueProductsSet = <String, Product>{};

          // Add existing products to the set
          for (var product in existingProducts) {
            uniqueProductsSet[product.code] = product; // Assuming each product has a unique `code`
          }

          // Add new products to the set
          for (var product in newProducts) {
            uniqueProductsSet[product.code] = product; // This will ensure duplicates are not added
          }

          // Convert the set back to a list
          final uniqueProductsList = uniqueProductsSet.values.toList();
          return AsyncValue.data(uniqueProductsList);
        },
        loading: () {
          // If currently loading, return new products
          return AsyncValue.data(newProducts);
        },
        error: (error, stackTrace) {
          // In case of an error, still return new products to update UI
          return AsyncValue.data(newProducts);
        },
      );
    } catch (e, stackTrace) {
      if (e is RangeError) {
        // If error is RangeError, preserve previous state
        state = AsyncValue.data(state.value ?? []); // Keep existing data
      } else {
        state = AsyncValue.error(e, stackTrace);
      }
    }
  }

  Future<void> _initializeIfNeeded() async {
    if (!_categoryNotifier.state.hasValue) {
      await _selectedCateNotifier.initializeTagCodes(); // Fetch categories only if not already loaded
    }
  }
}

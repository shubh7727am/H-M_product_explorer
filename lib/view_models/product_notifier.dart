import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service..dart';


final productNotifierProvider = StateNotifierProvider<ProductNotifier, AsyncValue<List<Product>>>((ref) {
  return ProductNotifier(ref.read(productServiceProvider));
});

class ProductNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  final ProductService _productService;

  ProductNotifier(this._productService) : super(const AsyncValue.loading());

  Future<void> fetchProducts(int page) async {
    try {
      final newProducts = await _productService.fetchProducts(page);

      // Append new products to the existing list
      state = state.when(
        data: (existingProducts) {
          return AsyncValue.data([...existingProducts, ...newProducts]);
        },
        loading: () {
          // If currently loading, initialize with new products
          return AsyncValue.data(newProducts);
        },
        error: (error, stackTrace) {
          // In case of an error state, replace with new data
          return AsyncValue.data(newProducts);
        },
      );
    } catch (e, stackTrace) {
      if (e is RangeError) {
        // If error is RangeError, show the message but preserve the previous state
        state = AsyncValue.data(state.value ?? []);  // Keep existing data
        // Optionally, log the error or show a message on the UI
        print('No more items found: $e');
      } else {
        // In case of any other error, preserve the previous state
        state = AsyncValue.error(e, stackTrace);
      }
    }
  }
}



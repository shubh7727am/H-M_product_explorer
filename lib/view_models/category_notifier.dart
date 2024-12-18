import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import '../services/product_service..dart';


final cateGoryNotifierProvider = StateNotifierProvider<CategoryNotifier, AsyncValue<List<Cate>>>((ref) {
  return CategoryNotifier(ref.read(productServiceProvider));
});

class CategoryNotifier extends StateNotifier<AsyncValue<List<Cate>>> {
  final ProductService _productService;

  CategoryNotifier(this._productService) : super(const AsyncValue.loading());

  Future<void> fetchCategories() async {
    try {
      // Check if categories already exist
      if (state.hasValue) {
        // Categories are already loaded; skip fetching
        return;
      }

      // Fetch categories from the service
      final newCate = await _productService.fetchCategories();

      // Store the categories only once
      state = AsyncValue.data(newCate);
    } catch (error, stackTrace) {
      // Handle errors appropriately
      state = AsyncValue.error(error, stackTrace);
    }
  }

  // Method to get all tag codes from the fetched categories
  List<dynamic> getAllTagCodes() {
    if (state.hasValue) {
      // Extracting tagCodes from each Cate object
      return state.value!.expand((cate) => cate.tagCodes ?? []).toList();
    }
    return []; // Return empty list if there are no categories
  }
}



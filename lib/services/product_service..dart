import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/category.dart';
import '../models/product.dart';

final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService();
});

class ProductService {
  // Common headers for API requests
  Map<String, String> _getHeaders() {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'x-rapidapi-ua': 'RapidAPI-Playground',
      'x-rapidapi-key': '84d8da1ab0msha45651931b274e7p1eae1bjsn3bcac7dd61be',
      'x-rapidapi-host': 'apidojo-hm-hennes-mauritz-v1.p.rapidapi.com',
    };
  }
// fetching categories
  Future<List<Cate>> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse(
            "https://apidojo-hm-hennes-mauritz-v1.p.rapidapi.com/categories/list?lang=en&country=us"),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Cate.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Failed to fetch categories: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      rethrow;
    }
  }
// fetching products on the basis of tag_codes
  Future<List<Product>> fetchProducts(int page, List<dynamic> categories) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://apidojo-hm-hennes-mauritz-v1.p.rapidapi.com/products/list?country=us&lang=en&currentpage=$page&pagesize=30&categories=${categories.join(":")}&concepts=H%26M%20MAN'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> results = data['results'] ?? [];
        return results.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch products: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching products: $e');
      rethrow;
    }
  }
}

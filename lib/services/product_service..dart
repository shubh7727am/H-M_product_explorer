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


  Future<List<Cate>> fetchCategories() async {





    final response = await http.get(
      Uri.parse("https://apidojo-hm-hennes-mauritz-v1.p.rapidapi.com/categories/list?lang=en&country=us"),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'x-rapidapi-ua': 'RapidAPI-Playground',
        'x-rapidapi-key': '2da3064783msh4f17f98a3e8becap115903jsn04bea0611240',
        'x-rapidapi-host': 'apidojo-hm-hennes-mauritz-v1.p.rapidapi.com',
      },
    );



    if (response.statusCode == 200) {


      final List<dynamic> data = jsonDecode(response.body) ;


      List<Cate> cate = data.map((json) => Cate.fromJson(json as Map<String, dynamic>)).toList();






      return cate;
    } else {
      throw Exception('Failed to load products');

    }
  }




  Future<List<Product>> fetchProducts(int page , List<dynamic> categories) async {
    final response = await http.get(
      Uri.parse('https://apidojo-hm-hennes-mauritz-v1.p.rapidapi.com/products/list?country=us&lang=en&currentpage=$page&pagesize=30&categories=${categories.join(":")}&concepts=H%26M%20MAN'), headers  : {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'x-rapidapi-ua': 'RapidAPI-Playground',
    'x-rapidapi-key': '2da3064783msh4f17f98a3e8becap115903jsn04bea0611240',
    'x-rapidapi-host': 'apidojo-hm-hennes-mauritz-v1.p.rapidapi.com',
    }
    );

    final Map<String,dynamic> data = json.decode(response.body);
   // print(data['results'].map((json) => Product.fromJson(json)).toList());


    if (response.statusCode == 200) {
      final Map<String,dynamic> data = json.decode(response.body);

      final List<dynamic> _filteredData = data['results'];
      return _filteredData.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');

    }
  }
}

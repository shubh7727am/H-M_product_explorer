class Product {
  final String name;
  final String code;
  final double price;
  final String imageUrl;

  Product({required this.name, required this.imageUrl, required this.price , required this.code});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'], price: json['price']['value'], imageUrl: json['images'][0]['url'],code: json['code']);
  }

}
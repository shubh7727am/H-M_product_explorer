class Product {
  final String name;

  final double price;
  final String imageUrl;

  Product({required this.name, required this.imageUrl, required this.price});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'], price: json['price']['value'], imageUrl: json['images'][0]['url'],);
  }

}
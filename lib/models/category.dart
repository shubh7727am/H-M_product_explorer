class Cate {
  final String? catName;
  final List<Cate>? catSublist; // Change to List<Cate> to handle nested categories
  final List<dynamic>? tagCodes;

  Cate({required this.catName, required this.catSublist, required this.tagCodes});

  factory Cate.fromJson(Map<String, dynamic> json) {
    return Cate(
      catName: json['CatName'],
      catSublist: (json['CategoriesArray'] as List<dynamic>?)
          ?.map((item) => Cate.fromJson(item as Map<String, dynamic>))
          .toList(),
      tagCodes: json['tagCodes'],
    );
  }
}

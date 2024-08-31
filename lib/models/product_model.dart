import 'package:flutter_ecommerce/models/category_model.dart';

class ProductModel {
  final int id;
  final String title;
  final int price;
  final String description;
  final CategoryModel category;
  final List images;

  ProductModel(
      {required this.id,
      required this.title,
      required this.price,
      required this.description,
      required this.category,
      required this.images});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
        id: json["id"],
        title: json["title"],
        price: json["price"],
        description: json["description"],
        category: CategoryModel.fromJson(json["category"]),
        images: json["images"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['category'] = category.toJson();
    data['images'] = images;
    return data;
  }
}

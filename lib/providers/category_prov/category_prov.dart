import 'package:flutter_ecommerce/models/category_model.dart';
import 'package:flutter_ecommerce/services/category_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getCategoryProvider = FutureProvider<List<CategoryModel>>((ref) async {
  return await CategoryService.getCategories();
});

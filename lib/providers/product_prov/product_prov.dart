import 'package:flutter_ecommerce/models/product_model.dart';
import 'package:flutter_ecommerce/services/product_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getProductProvider = FutureProvider<List<ProductModel>>((ref) async {
  return await ProductService.getProducts(offset: 0, limit: 100);
});

final getArrivalProvider = FutureProvider<List<ProductModel>>((ref) async {
  return await ProductService.getProducts(offset: 0, limit: 4);
});

final getTrendingProvider = FutureProvider<List<ProductModel>>((ref) async {
  return await ProductService.getProducts(offset: 4, limit: 4);
});

final productIdProv = StateProvider<int>((ref) => 0);

final productPriceProvider = StateProvider<int>((ref) => 0);

final getProductInfoProvider = FutureProvider<ProductModel>((ref) async {
  return await ProductService.getProductInfo(ref.watch(productIdProv));
});

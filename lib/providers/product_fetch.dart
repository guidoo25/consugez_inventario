import 'package:consugez_inventario/models/update.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import 'package:consugez_inventario/models/product.dart';
import 'package:consugez_inventario/theme/enviroments.dart';

final productProviderfetch = StateNotifierProvider<ProductNotifier, List<Product>>((ref) {
  return ProductNotifier();
});

final productProviderUpdate = StateNotifierProvider<ProductUpdate, List<StockUpdatesLog>>((ref) {
  return ProductUpdate();
});

class ProductNotifier extends StateNotifier<List<Product>> {
  ProductNotifier() : super([]);

  final Dio dio = Dio(BaseOptions(baseUrl: '${Enviroments.apiurl}/'));

  Future<void> fetchProducts() async {
    try {
      final response = await dio.get('products');
      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final productResponse = ProductResponse.fromJson(jsonResponse);
        state = productResponse.producto;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }


}

class ProductUpdate extends StateNotifier<List<StockUpdatesLog>> {
  ProductUpdate() : super([]);
  final Dio dio = Dio(BaseOptions(baseUrl: '${Enviroments.apiurl}/'));


  Future <List<StockUpdatesLog>> fetchProductById(String id) async {
    try {
      final response = await dio.get('productslogs/$id');
      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final products = Updateresponse.fromJson(jsonResponse);
        return  products.stockUpdatesLog;
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }

}
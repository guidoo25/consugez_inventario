import 'package:consugez_inventario/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductNotifier extends StateNotifier<List<Product>> {
  ProductNotifier() : super([]);
  List<Product> productss = [];
  List<Product> _productoss = [];

  String _searchQuery = '';

  void searchProducts(String query) {
    _searchQuery = query;
    state = state;
  }

  List<Product> get products {
    if (_searchQuery.isEmpty) {
      return _productoss;
    } else {
      return _productoss
          .where((product) => product.category!
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  void addProduct(Product product) {
    state = List.from(state)..add(product);
  }

  void removeProduct(String productId) {
    state = List.from(state)
      ..removeWhere((product) => product.category == productId);
  }
}

final productProvider = StateNotifierProvider<ProductNotifier, List<Product>>(
    (ref) => ProductNotifier());

import 'package:consugez_inventario/models/product.dart';
import 'package:consugez_inventario/theme/enviroments.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:consugez_inventario/providers/product_state.dart';

class ProductList extends ConsumerStatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends ConsumerState<ProductList> {
  List<Product> _allProducts = [];
  List<Product> _foundProducts = [];
  final Dio dio = Dio(BaseOptions(baseUrl: '${Enviroments.apiurl}/'));

  void _runFilter(String enteredKeyword) {
    List<Product> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allProducts;
    } else {
      results = _allProducts
          .where((product) => product.category!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundProducts = results;
    });
  }

  Future<void> fetchProducts() async {
    final response = await dio.get('products');
    if (response.statusCode == 200) {
      final jsonResponse = response.data;
      final productResponse = ProductResponse.fromJson(jsonResponse);
      setState(() {
        _allProducts = productResponse.producto;
        _foundProducts = _allProducts;
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  void initState() {
    fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Buscar producto',
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  searchController.clear();
                  _runFilter('');
                },
              ),
            ),
            onSubmitted: (value) {
              _runFilter(value);
            },
          ),
        ),
        Expanded(
          child: _foundProducts.isNotEmpty
              ? ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _foundProducts.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text('${_foundProducts[index].name}'),
                        subtitle:
                            Text('Codigo: ${_foundProducts[index].category}'),
                        onTap: () => ref
                            .read(productProvider.notifier)
                            .addProduct(_foundProducts[index]),
                        trailing: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            ref
                                .read(productProvider.notifier)
                                .addProduct(_foundProducts[index]);
                          },
                        ),
                      ),
                    );
                  },
                )
              : const Text(
                  'No se encontraron resultados',
                  style: TextStyle(fontSize: 24),
                ),
        ),
      ],
    );
  }
}

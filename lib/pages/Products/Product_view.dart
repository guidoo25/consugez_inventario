import 'package:consugez_inventario/pages/Products/Products_update.dart';
import 'package:consugez_inventario/providers/product_state.dart';
import 'package:consugez_inventario/theme/enviroments.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:consugez_inventario/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductView extends ConsumerStatefulWidget {
  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends ConsumerState<ProductView> {
  final Dio dio = Dio(BaseOptions(baseUrl: '${Enviroments.apiurl}/'));
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _stock = TextEditingController();
  final _minstock = TextEditingController();
  final _searchController = TextEditingController();
  List<Product> _allProducts = [];
  List<Product> _foundProducts = [];
  String users = '';

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _stock.dispose();
    _minstock.dispose();
    _searchController.dispose();
    super.dispose();
  }

  getuserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('sol');
    print(user);
    if (user != null) {
      setState(() {
        users = user;
      });
    }
    return user;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        name: _nameController.text,
        category: _categoryController.text,
        stock: int.parse(_stock.text),
        minStock: int.parse(_minstock.text),
      );
      ref.read(productProvider.notifier).addProduct(product);
      Navigator.pop(context);
    }
  }

  void _runFilter(String enteredKeyword) {
    List<Product> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allProducts;
    } else {
      results = _allProducts
          .where((product) => product.name!
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

  Future<void> updateSotckValue(int id, int stock, String user) async {
    final response = await dio
        .put('productos/$id', data: {'quantity': stock, 'user_name': user});
    if (response.statusCode == 200) {
      setState(() {
        fetchProducts();
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  void initState() {
    fetchProducts();
    getuserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String values = '';
    return Scaffold(
        appBar: AppBar(
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductoUpdatelogs()),
                  );
                },
                child: Text('Historial Actualizaciones')),
          ],
          title: Text('Productos'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Buscar producto',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text('${_foundProducts[index].name}'),
                                subtitle: Text(
                                    'Codigo: ${_foundProducts[index].category}'),
                                trailing: IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    //ref.read(productProvider.notifier).addProduct(_foundProducts[index]);
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title:
                                                const Text('Aumentar Cantidad'),
                                            content: TextFormField(
                                              // initialValue y onFieldSubmitted dependen de tu implementación
                                              initialValue: '1',
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: (value) {
                                                //guardar el valor
                                                values = value;
                                              },
                                            ),
                                            actions: [
                                              TextButton(
                                                child: Text('Aceptar'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  updateSotckValue(
                                                      _foundProducts[index].id!,
                                                      int.parse(values),
                                                      users);

                                                  setState(() {});
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Stock Disponible: ${_foundProducts[index].stock}'),
                                    Text(
                                        'Min Stock: ${_foundProducts[index].minStock}'),
                                  ],
                                ),
                              ),
                            ],
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
        ));
  }
}

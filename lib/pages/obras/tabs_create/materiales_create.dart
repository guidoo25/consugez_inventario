import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:consugez_inventario/theme/enviroments.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CreateProductScreen extends StatefulWidget {
  @override
  _CreateProductScreenState createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _imageController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _stockController = TextEditingController();
  final _minStockController = TextEditingController();
  final _unidadController = TextEditingController();
  List<String> _categories = [
    'u',
    'm',
    'gbl',
    'm2',
    'litros',
    'kg',
    'lb',
  ]; // Empty list for categories

  @override
  void dispose() {
    _nameController.dispose();
    _imageController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _stockController.dispose();
    _minStockController.dispose();
    _unidadController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final image = _imageController.text;
      final price = _priceController.text;
      final codigo = _categoryController.text;
      final stock = _stockController.text;
      final minStock = _minStockController.text;
      final unidad = _unidadController.text;

      final url = '${Enviroments.apiurl}/products';

      try {
        final response = await Dio().post(
          url,
          data: {
            'name': name.toString(),
            'image': image.toString(),
            'price': price.toString(),
            'category': codigo.toString(),
            'stock': stock.toString(),
            'min_stock': minStock.toString(),
            'unidad': unidad.toString(),
            'userid': '28'
          },
        );
        final createdProduct = response.data['product'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Material Creado Correctamente'),
          ),
        );
        // Do something with the created product
      } catch (e) {
        if (e is DioError) {
          print("Error message: ${e.response?.data}");
        } else {
          print("Unexpected error: $e");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Materiales '),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Codigo',
                  border: OutlineInputBorder(),
                  hintText: 'Ingresar codigo',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un codigo';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Descriccion',
                  border: OutlineInputBorder(),
                  hintText: 'Enter a description',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Precio (Optional)',
                  border: OutlineInputBorder(),
                  hintText: 'Ingresa el precio',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un precio';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _stockController,
                decoration: InputDecoration(
                  labelText: 'Stock',
                  border: OutlineInputBorder(),
                  hintText: 'Ingresa el stock',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un stock';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              CustomDropdown<String>(
                closedBorder: Border.all(color: Colors.grey),
                expandedBorder: Border.all(color: Colors.grey),
                closedFillColor: Colors.white30,
                hintText: 'Unidad de medida',
                items: _categories,
                initialItem: _categories[0],
                onChanged: (value) {
                  _unidadController.text = value;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _minStockController,
                decoration: InputDecoration(
                  labelText: 'Min Stock (Opcional)',
                  border: OutlineInputBorder(),
                  hintText: 'Ingresa el min stock',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un min stock';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Crear'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

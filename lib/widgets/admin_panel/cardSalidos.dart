import 'package:consugez_inventario/models/analitica/masvendidos.dart';
import 'package:consugez_inventario/theme/enviroments.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecentlySoldProductsWidget extends StatefulWidget {
  @override
  _RecentlySoldProductsWidgetState createState() =>
      _RecentlySoldProductsWidgetState();
}

class _RecentlySoldProductsWidgetState
    extends State<RecentlySoldProductsWidget> {
  List<dynamic> _products = [];
  @override
  void initState() {
    super.initState();
    _fetchRecentlySoldProducts();
  }

  Future<List<Masvendidos>> _fetchRecentlySoldProducts() async {
    final response =
    await http.get(Uri.parse('${Enviroments.apiurl}/masvendidos'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Masvendidos.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load productos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Agregar elevación para un efecto de tarjeta
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text(
                'Artículos que más salieron en el último mes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              leading: Icon(
                Icons.shopping_cart, // Icono de carrito de compra
                color: Colors.blue, // Color del icono
              ),
            ),
            FutureBuilder<List<Masvendidos>>(
              future: _fetchRecentlySoldProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Text('No se encontraron productos');
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (ctx, index) => ListTile(
                      title: Text(snapshot.data![index].name),
                      subtitle: Text(
                        'Cantidad de salida: ${snapshot.data![index].quantitySold}',
                        style: TextStyle(
                          color: Colors.green, // Color del texto
                        ),
                      ),
                      leading: Icon(
                        Icons.check_circle, // Icono de marca de verificación
                        color: Colors.green, // Color del icono
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

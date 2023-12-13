import 'dart:convert';

import 'package:consugez_inventario/models/analitica/pocostock.dart';
import 'package:consugez_inventario/theme/enviroments.dart';
import 'package:consugez_inventario/theme/responsive.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PocoStockCard extends StatelessWidget {
  const PocoStockCard({Key? key}) : super(key: key);

  Future<List<Pocostock>> _fetchProductos() async {
    final response = await http.get(Uri.parse('${Enviroments.apiurl}/pocoStock'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Pocostock.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load productos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(

      padding: const EdgeInsets.all(8.0),
      child: Card(


        margin: EdgeInsets.only(bottom: Responsive.isMobile(context) ? 20 : 0),
        surfaceTintColor: Colors.blue,

        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: FutureBuilder<List<Pocostock>>(
          future: _fetchProductos(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final productos = snapshot.data!;
              final lowStockCount = productos.where((p) => p.newStock < 30).length;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(Icons.show_chart, color: Colors.blue, size: 32),
                    title: Text(
                      'Productos con poco stock',
                      style: TextStyle(
                        fontSize: 24, // Tamaño de fuente personalizado
                        fontFamily: 'TuFuentePersonalizada', // Reemplaza con tu fuente personalizada
                        color: Colors.black, // Color de texto personalizado
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '$lowStockCount productos con menos de 30 unidades en stock',
                      style: TextStyle(
                        fontSize: 16, // Tamaño de fuente personalizado
                        fontFamily: 'TuFuentePersonalizada', // Reemplaza con tu fuente personalizada
                        color: Colors.grey, // Color de texto personalizado
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: productos.length,
                      itemBuilder: (context, index) {
                        final producto = productos[index];
                        if (producto.newStock < 30) {
                          return ListTile(
                            title: Text(
                              producto.name,
                              style: TextStyle(
                                fontSize: 18, // Tamaño de fuente personalizado
                                fontFamily: 'TuFuentePersonalizada', // Reemplaza con tu fuente personalizada
                                color: Colors.black, // Color de texto personalizado
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Stock Actual: ${producto.newStock}',
                              style: TextStyle(
                                fontSize: 14, // Tamaño de fuente personalizado
                                fontFamily: 'TuFuentePersonalizada', // Reemplaza con tu fuente personalizada
                                color: Colors.grey, // Color de texto personalizado
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return ListTile(
                title: Text('Error al cargar los productos'),
                subtitle: Text(
                  snapshot.error.toString(),
                  style: TextStyle(
                    fontSize: 16, // Tamaño de fuente personalizado
                    fontFamily: 'TuFuentePersonalizada', // Reemplaza con tu fuente personalizada
                    color: Colors.red, // Color de texto personalizado
                  ),
                ),
              );
            } else {
              return ListTile(
                title: Text('Cargando productos...'),
                leading: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

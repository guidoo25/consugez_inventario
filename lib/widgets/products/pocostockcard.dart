import 'package:consugez_inventario/models/analitica/masvendidos.dart';
import 'package:consugez_inventario/models/analitica/noSale.dart';
import 'package:consugez_inventario/theme/enviroments.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class CardNosale extends StatefulWidget {
  @override
  _RecentlySoldProductsWidgetState createState() =>
      _RecentlySoldProductsWidgetState();
}

class _RecentlySoldProductsWidgetState
    extends State<CardNosale> {
  @override
  void initState() {
    super.initState();
    _fetchRecentlySoldProducts();
  }

  Future<List<NoSale>> _fetchRecentlySoldProducts() async {
    final response =
    await http.get(Uri.parse('${Enviroments.apiurl}/pocoStock'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => NoSale.fromJson(json)).toList();
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
                'Articulos con poca Salida',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              leading: Icon(
                Icons.remove_shopping_cart_outlined, // Icono de carrito de compra
                color: Colors.blue, // Color del icono
              ),
            ),
            FutureBuilder<List<NoSale>>(
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
                        'Cantidad disponible: ${snapshot.data![index].newStock}',
                        style: TextStyle(
                          color: Colors.deepOrangeAccent, // Color del texto
                        ),
                      ),
                      leading: Icon(
                        Icons.indeterminate_check_box_sharp, // Icono de marca de verificación
                        color: Colors.orange, // Color del icono
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

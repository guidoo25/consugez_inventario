import 'dart:convert';

import 'package:consugez_inventario/models/guiaResponse.dart';
import 'package:consugez_inventario/theme/enviroments.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GuiaDetailsScreen extends StatefulWidget {
  @override
  _GuiaDetailsScreenState createState() => _GuiaDetailsScreenState();
}

class _GuiaDetailsScreenState extends State<GuiaDetailsScreen> {
  Future<List<GuiaResponse>> getGuiaResponse() async {
    final response = await http.get(Uri.parse('${Enviroments.apiurl}/guia'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => GuiaResponse.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load guia');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial Guias'),
      ),
      body: FutureBuilder<List<GuiaResponse>>(
        future: getGuiaResponse(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final productos = snapshot.data![index].detalleProducto.productos;
                final guia = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ExpansionTile(
                    backgroundColor: Colors.white,
                    childrenPadding: EdgeInsets.all(10),
                    title: Container(
                      // decoration: BoxDecoration(
                      //   image: DecorationImage(
                      //     image: AssetImage('assets/papel.png'),
                      //     fit: BoxFit.cover,
                      //   ),
                      // ),
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "GUIA #: 001-001-${snapshot.data![index].direccionCliente}",
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                      ),
                    ),
                    children: [
                      ListTile(
                        // subtitle: Text('Fecha: ${guia.guiaValue[0].fechaFin}'),
                        title: Text('Cliente: ${guia.nombreCliente}'),
                      ),
                      Divider(),
                      Text("Articulos Utilizados",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      for (final producto in productos)
                        ListTile(
                          title: Text('Codigo: ${producto.codigo}'),
                          subtitle: Text('Nombre: ${producto.nombre}, Cantidad Despachada: ${producto.cantidad}'),
                        ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

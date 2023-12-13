import 'package:consugez_inventario/models/itemdetails.dart';
import 'package:consugez_inventario/models/product.dart';

import 'package:consugez_inventario/providers/product_state.dart';
import 'package:consugez_inventario/theme/enviroments.dart';
import 'package:consugez_inventario/widgets/Guia/ProductList.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class ProductTableForm extends ConsumerStatefulWidget {
  final List<Product> productos;

  ProductTableForm({required this.productos});

  @override
  _ProductTableState createState() => _ProductTableState();
}

class _ProductTableState extends ConsumerState<ProductTableForm> {
  String stockstatus = "";
  int? productIndex;
  String apiurl = Enviroments.apiurl;
  List<ItemDetails> itemDetailsList = [];

  Future<void> _checkStock(String codigo, double qnty) async {
    final response = await http.get(
      Uri.parse('$apiurl/checkStock/$codigo/$qnty'),
      headers: {'Content-Type': 'application/json'},
    );
    stockstatus = response.body;
  }

  void _chekStocksatus(double qnty) async {
    if (productIndex != null) {
      final product = widget.productos[productIndex!];
      await _checkStock(product.id.toString(), qnty);
      if (stockstatus.contains("El Stock es insuficiente")) {
        setState(() {
          product.stockStatus = stockstatus;
          itemDetailsList = getDetails();
        });
      } else {
        setState(() {
          product.stockStatus = "Disponible";
          itemDetailsList = getDetails();
        });
      }
    }
  }

  void _qtyinthismoment(double qnty) async {
    if (productIndex != null) {
      final valueqty = widget.productos[productIndex!];
      setState(() {
        valueqty.inCart = qnty.toInt();
      });
    }
  }

  Future<void> updateStock(
      int productId, int stockChange, String operation, int clienteid) async {
    // Añadir la operación al objeto de datos
    final data = {
      'stockChange': stockChange,
      'operation': operation,
      'clienteid': clienteid,
    };

    final response =
        await Dio().put('${Enviroments.apiurl}/stock/$productId', data: data);

    print(data);
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.read(productProvider);

    final screnwidth = MediaQuery.of(context).size.width;
    final columnSpacing = screnwidth * 0.10;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SingleChildScrollView(
              child: DataTable(
                columnSpacing: columnSpacing, // Espacio entre columnas
                headingRowHeight: 50,
                dataRowHeight: 60,
                columns: [
                  DataColumn(
                    label: Text(
                      'Cantidad *',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Codigo *',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Descripcion *",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Accion",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Estado",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
                rows: List<DataRow>.generate(
                  products.length,
                  (index) => DataRow(cells: [
                    DataCell(
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        initialValue: "1",
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        onFieldSubmitted: (value) {
                          _chekStocksatus(double.parse(value));
                          _qtyinthismoment(double.parse(value));
                          productIndex = null;
                        },
                        onTap: () {
                          productIndex = index;
                        },
                      ),
                    ),
                    DataCell(Text(products[index].category.toString())),
                    DataCell(Text(products[index].name.toString())),
                    DataCell(
                      IconButton(
                        onPressed: () {
                          ref.read(productProvider.notifier).removeProduct(
                              products[index].category.toString());
                        },
                        icon: Icon(Icons.delete_forever),
                        color: Colors.red,
                      ),
                    ),
                    DataCell(Text(products[index].stockStatus.toString())),
                  ]),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Container(
                              width: double.maxFinite,
                              child: ProductList(),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Cerrar'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text("Agregar productos"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  List<ItemDetails> getDetails() {
    List<ItemDetails> details = [];
    for (var i = 0; i < widget.productos.length; i++) {
      details.add(ItemDetails(
        name: widget.productos[i].name.toString(),
        qty: widget.productos[i].stockStatus.toString(),
        Codigo: widget.productos[i].id.toString(),
      ));
    }
    return details;
  }
}

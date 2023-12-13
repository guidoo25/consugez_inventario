import 'dart:convert';
import 'dart:io';

import 'package:consugez_inventario/models/itemdetails.dart';
import 'package:consugez_inventario/models/obras_model.dart';
import 'package:consugez_inventario/models/product.dart';
import 'package:consugez_inventario/pages/obras/tabs_create/Aumentar_Material_lista.dart';
import 'package:consugez_inventario/providers/product_state.dart';
import 'package:consugez_inventario/theme/enviroments.dart';
import 'package:csv/csv.dart';
import 'package:davi/davi.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class TablaAsignarMats extends ConsumerStatefulWidget {
  final List<Product> productos;
  final Obra obra;

  const TablaAsignarMats({
    Key? key,
    required this.productos,
    required this.obra,
  }) : super(key: key);

  @override
  _TablasObrasAumentoState createState() => _TablasObrasAumentoState();
}

class _TablasObrasAumentoState extends ConsumerState<TablaAsignarMats> {
  List<List<dynamic>> _data = [];

  String values = '1';
  String stockstatus = "";
  int? productIndex;
  String apiurl = Enviroments.apiurl;
  List<ItemDetails> itemDetailsList = [];
//////funciones para importar productos desde un archivo csv
  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.first;

      final input = new File(file.path!).openRead();
      final fields = await input
          .transform(latin1.decoder)
          .transform(new CsvToListConverter(fieldDelimiter: ';'))
          .toList();
      //mappear los fields a la lista de productos
      for (var i = 0; i < fields.length; i++) {
        if (fields[i].isNotEmpty) {
          final product = Product(
            inCart: fields[i][2].toInt(),
            category: fields[i][0].toString(),
            name: fields[i][1].toString(),
          );
          setState(() {
            ref.read(productProvider.notifier).addProduct(product);
          });
        } else {
          print('Row $i is empty');
        }
      }
    }
    ;
  }

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

  Future<void> asignarMateriales(String idObra, String materialUtilizado,
      String cantidad, String codigoMaterial, String Date) async {
    final url = '${Enviroments.apiurl}/obras/$idObra/asignar-materiales';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'materialUtilizado': materialUtilizado,
          'cantidad': cantidad,
          'codigoMaterial': codigoMaterial,
          'fecha': Date,
        }),
      );

      if (response.statusCode == 200) {
        print('Material asignado a la obra exitosamente');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Material asignado a la obra exitosamente')),
        );
      } else {
        print('Error al asignar material: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error al asignar material: ${response.body}')),
        );
      }
    } catch (e) {
      print('Error al asignar material: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al asignar material: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Builder(
            builder: (context) {
              DaviModel<Product> model = DaviModel<Product>(
                rows: widget.productos,
                columns: [
                  DaviColumn(
                      name: 'Cantidad ',
                      cellBuilder: (context, rowData) {
                        return TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          initialValue: rowData.data.inCart.toString(),
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
                            productIndex = rowData.index;
                          },
                        );
                      }),
                  DaviColumn(
                    name: 'Codigo',
                    stringValue: (data) => data.category,
                  ),
                  DaviColumn(
                    name: 'Descripcion',
                    stringValue: (data) => data.name,
                  ),
                  DaviColumn(
                      name: 'Accion ',
                      cellBuilder: (context, rowData) {
                        return IconButton(
                          onPressed: () {
                            ref.read(productProvider.notifier).removeProduct(
                                  rowData.data.category.toString(),
                                );
                          },
                          icon: Icon(Icons.delete_forever),
                          color: Colors.red,
                        );
                      }),
                  DaviColumn(
                    name: 'Estado Stock',
                    stringValue: (data) => data.stockStatus,
                  ),
                ],
              );

              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: DaviTheme(
                  child: Davi<Product>(model),
                  data: DaviThemeData(
                    row: const RowThemeData(
                      dividerThickness: 4,
                      dividerColor: Colors.black12,
                    ),
                    header: HeaderThemeData(
                      color: const Color.fromARGB(255, 232, 238, 245),
                      bottomBorderHeight: 4,
                      bottomBorderColor: Colors.black45,
                    ),
                    headerCell: HeaderCellThemeData(
                      height: 40,
                      alignment: Alignment.center,
                      textStyle: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      resizeAreaWidth: 10,
                      resizeAreaHoverColor: Colors.blue.withOpacity(.3),
                      sortIconColors: SortIconColors.all(Colors.blueAccent),
                      expandableName: false,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
          child: ElevatedButton(
              child: Text('Asignar Materiales'),
              onPressed: () async {
                final details = getDetails();

                for (var i = 0; i < widget.productos.length; i++) {
                  final product = widget.productos[i];
                  if (widget.obra.id != null &&
                      product.name != null &&
                      product.inCart != null &&
                      product.category != null) {
                    await asignarMateriales(
                        widget.obra.id.toString(),
                        product.name.toString(),
                        product.inCart!.toString(),
                        product.category.toString(),
                        DateTime.now().toString());
                  } else {
                    print('Uno de los valores es nulo');
                    print('widget.obra.id: ${widget.obra.id}');
                    print('product.name: ${product.name}');
                    print('product.inCart: ${product.inCart}');
                    print('product.id: ${product.category}');
                  }
                }
              }),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
          child: ElevatedButton(
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
            style: ElevatedButton.styleFrom(
              textStyle: TextStyle(fontSize: 16), // Tamaño del texto del botón
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
          child: ElevatedButton(
            onPressed: () {
              pickFile();
            },
            child: Text("Importar productos"),
            style: ElevatedButton.styleFrom(
              textStyle: TextStyle(fontSize: 16), // Tamaño del texto del botón
            ),
          ),
        ),
      ],
    );
    //dame un boton flotante
  }
}

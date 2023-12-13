import 'dart:convert';

import 'package:consugez_inventario/models/guiaResponse.dart';
import 'package:consugez_inventario/models/itemdetails.dart';
import 'package:consugez_inventario/models/product.dart';
import 'package:consugez_inventario/models/ptoEmision.dart';
import 'package:consugez_inventario/providers/clientprovider.dart';
import 'package:consugez_inventario/providers/formfield.dart';
import 'package:consugez_inventario/providers/guiastate.dart';
import 'package:consugez_inventario/providers/product_state.dart';
import 'package:consugez_inventario/theme/enviroments.dart';
import 'package:consugez_inventario/widgets/Guia/ProductList.dart';
import 'package:davi/davi.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ProductTable extends ConsumerStatefulWidget {
  final List<Product> productos;

  ProductTable({required this.productos});

  @override
  _ProductTableState createState() => _ProductTableState();
}

class _ProductTableState extends ConsumerState<ProductTable> {
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

  void enviarGuia(List<Map<String, dynamic>> detalles) async {
    final url = Uri.parse('${Enviroments.apiphp}/facturas.php');

    // Convierte la lista de detalles a JSON
    final detallesJson = jsonEncode(detalles);
    print(detallesJson);

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: detallesJson,
    );
    print(detallesJson);
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final enviarGuiaState = ref.watch(enviarGuiaProvider);
    final formsData = ref.read(formDataProvider);
    final cliente = ref.read(clientProvider);
    final products = ref.read(productProvider);
    final listadeitems = widget.productos
        .map((item) => {
              'codigo': item.category.toString(),
              'descripcion': item.name.toString(),
              'cantidad': item
                  .inCart, // Debes usar un número en lugar de item.inCart.toString()
              'razonSocialTransportista': formsData['transportista'],
              'establecimiento':
                  "001", // Agrega un valor para 'establecimiento'
              'ptoEmision': "001", // Agrega un valor para 'ptoEmision'
              'secuencial': formsData['secuencial'],
              'fechaIniTransporte':
                  formsData['fechainicio'], // Formato "dd/mm/aaaa"
              'idDestinatario': cliente?.ruc,
              'razonSocialDestinatario': cliente?.razonSocialComprador,
              'dirDestinatario': cliente?.dirreccionCliente,
              'correoComprador': cliente?.correo,
              'motivoTraslado': formsData['motivo'],
              'direccionPartida': formsData['direccion'],
              'rucTransportista': formsData['ruc'],
              'fechaFin': formsData['fechafin'], // Formato "dd/mm/aaaa"
              'placa': formsData['placa'],
            })
        .toList();

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
                columns: [
                  DataColumn(
                      label: Text(
                    'Cantidad *',
                    style: TextStyle(fontSize: 18),
                  )),
                  DataColumn(
                      label: Text(
                    'Codigo *',
                    style: TextStyle(fontSize: 18),
                  )),
                  DataColumn(
                      label: Text(
                    "Descripcion *",
                    style: TextStyle(fontSize: 18),
                  )),
                  DataColumn(
                      label: Text(
                    "Accion",
                    style: TextStyle(fontSize: 18),
                  )),
                  DataColumn(
                      label: Text(
                    "Estado",
                    style: TextStyle(fontSize: 18),
                  )),
                ],
                rows: List<DataRow>.generate(
                  products.length,
                  (index) => DataRow(cells: [
                    DataCell(TextFormField(
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
                    )),
                    DataCell(Text(products[index].category.toString())),
                    DataCell(Text(products[index].name.toString())),
                    DataCell(IconButton(
                      onPressed: () {
                        ref
                            .read(productProvider.notifier)
                            .removeProduct(products[index].category.toString());
                      },
                      icon: Icon(Icons.delete_forever),
                      color: Colors.red,
                    )),
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
                      child: Text("Agregar productos")),
                  SizedBox(
                    height: 10,
                  ),
                  // if (enviarGuiaState.isLoading) CircularProgressIndicator(),
                  // if (enviarGuiaState.errorMessage != null) Text(enviarGuiaState.errorMessage!),
                  // if (enviarGuiaState.response != null)
                  //   enviarGuiaState.response == 'FIRMADO' || enviarGuiaState.response == 'AUTORIZADO'
                  //       ? Icon(Icons.check, color: Colors.green, size: 48)
                  //       : Icon(Icons.close, color: Colors.red, size: 48),
                  ElevatedButton(
                    onPressed: () async {
                      final details = getDetails();
                      ref
                          .read(enviarGuiaProvider.notifier)
                          .enviarGuia(listadeitems);
                      if (enviarGuiaState.isLoading) {
                        if (enviarGuiaState.response?.soapresponseReturn
                                .estadoComprobante ==
                            'FIRMADO') {
                          _generarNumeroFacturaDesdeHive();
                          //DISMINUCION DE STOCK EN LA BASE DE DATOS
                          for (var i = 0; i < widget.productos.length; i++) {
                            final product = widget.productos[i];
                            await updateStock(
                                int.parse(product.id.toString()),
                                int.parse(product.inCart.toString()),
                                'ventas',
                                cliente!.id);
                          }
                          print(enviarGuiaState
                              .response?.soapresponseReturn.estadoComprobante);
                          insertarRegistroGuia(
                              cliente!.razonSocialComprador,
                              formsData['secuencial'].toString(),
                              listadeitems,
                              widget.productos);
                        }
                      }
                    },
                    child: Text("Enviar", style: TextStyle(fontSize: 15)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<int> _obtenerUltimoNumeroFactura() async {
    //fetch info with Dio  for this link get api http://localhost:3000/api/factura/
    final response = await Dio().get('${Enviroments.apiurl}/numeroguia');
    final data = PtoemisionResponce.fromJson(response.data);
    final ultimoNumeroFactura = data.facturaUltimo;
    return ultimoNumeroFactura;
  }

  Future<String> _generarNumeroTemporal() async {
    // Obtener el primer punto de emisión guardado en Hive
    final numerofac = await _obtenerUltimoNumeroFactura();
    // Obtener los datos necesarios del punto de emisión
    final codigoPais = '001';
    final codigoSucursal = '001';
    final ultimoNumeroFactura = numerofac;

    final ultimoNumeroFacturaInt = ultimoNumeroFactura is int
        ? ultimoNumeroFactura
        : int.tryParse(ultimoNumeroFactura.toString());
    // Incrementar el último número de factura utilizado en 1
    final numeroFactura = ultimoNumeroFacturaInt! + 1;

    // Formatear el número incrementado con 8 dígitos utilizando NumberFormat
    final formatter = NumberFormat('000000000');
    final facturaNumber = formatter.format(numeroFactura);
    ref
        .read(formDataProvider.notifier)
        .updateValue('secuencial', facturaNumber);
    // Retornar un mapa con los valores de codigoPais, codigoSucursal y numeroFactura
    return facturaNumber;
  }

  _actualizarFactura(String Numeracion) async {
    final response =
        await Dio().put('${Enviroments.apiurl}/numeroguia/', data: {
      "numero_factura": Numeracion,
    });
    print(response);
  }

  Future<Map<String, dynamic>> _generarNumeroFacturaDesdeHive() async {
    // Obtener el primer punto de emisión guardado en Hive
    final numerofac = await _obtenerUltimoNumeroFactura();
    // Obtener los datos necesarios del punto de emisión
    final codigoPais = '001';
    final codigoSucursal = '001';
    final ultimoNumeroFactura = numerofac;

    final ultimoNumeroFacturaInt = ultimoNumeroFactura is int
        ? ultimoNumeroFactura
        : int.tryParse(ultimoNumeroFactura.toString());
    // Incrementar el último número de factura utilizado en 1
    final numeroFactura = ultimoNumeroFacturaInt! + 1;

    // Formatear el número incrementado con 8 dígitos utilizando NumberFormat
    final formatter = NumberFormat('000000000');

    final facturaNumber = formatter.format(numeroFactura);
    _actualizarFactura(facturaNumber);
    // Retornar un mapa con los valores de codigoPais, codigoSucursal y numeroFactura
    return {
      'codigoPais': codigoPais,
      'codigoSucursal': codigoSucursal,
      'numeroFactura': facturaNumber,
    };
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

  void insertarRegistroGuia(String Client, String direccion,
      List<Map<String, dynamic>> guianu, List<Product> productos) async {
    try {
      final detalleProductos = productos
          .map((product) => {
                'nombre': product.name,
                'cantidad': product.inCart,
                'codigo': product.category,
              })
          .toList();

      final response = await Dio().post(
        '${Enviroments.apiurl}/guia',
        data: {
          'nombre_cliente': Client,
          'direccion_cliente': direccion,
          'guia_value': {
            'guia': guianu,
          },
          'detalle_producto': {
            'productos': detalleProductos,
          },
        },
      );
      print(response.data);
    } catch (error) {
      print(error);
    }
  }
}

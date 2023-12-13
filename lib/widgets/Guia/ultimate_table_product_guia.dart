import 'dart:convert';

import 'package:consugez_inventario/models/itemdetails.dart';
import 'package:consugez_inventario/models/materiales_obra.dart';
import 'package:consugez_inventario/models/ptoEmision.dart';
import 'package:consugez_inventario/pages/obras/tabs_create/Aumentar_Material_lista.dart';
import 'package:consugez_inventario/providers/clientprovider.dart';
import 'package:consugez_inventario/providers/formfield.dart';
import 'package:consugez_inventario/providers/guiastate.dart';
import 'package:consugez_inventario/providers/product_state.dart';
import 'package:consugez_inventario/theme/enviroments.dart';
import 'package:davi/davi.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class TablaGuia extends ConsumerStatefulWidget {
  final List<Materiales> productos;

  const TablaGuia({
    Key? key,
    required this.productos,
  }) : super(key: key);

  @override
  _TablasObrasAumentoState createState() => _TablasObrasAumentoState();
}

class _TablasObrasAumentoState extends ConsumerState<TablaGuia> {
  String values = '1';
  String stockstatus = "";
  int? productIndex;
  String apiurl = Enviroments.apiurl;
  List<ItemDetails> itemDetailsList = [];

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
              'codigo': item.CodigoMaterial.toString(),
              'descripcion': item.MaterialUtilizado.toString(),
              'cantidad': item
                  .Cantidad, // Debes usar un número en lugar de item.inCart.toString()
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

    return Column(
      children: [
        Expanded(
          child: Builder(
            builder: (context) {
              DaviModel<Materiales> model = DaviModel<Materiales>(
                rows: widget.productos,
                columns: [
                  DaviColumn(
                    name: 'Cantidad ',
                    stringValue: (data) => data.Cantidad,
                  ),
                  DaviColumn(
                    name: 'Codigo',
                    stringValue: (data) => data.CodigoMaterial,
                  ),
                  DaviColumn(
                      name: 'Descripcion',
                      stringValue: (data) => data.MaterialUtilizado),
                  DaviColumn(
                      name: 'Accion ',
                      cellBuilder: (context, rowData) {
                        return IconButton(
                          onPressed: () {
                            ref.read(productProvider.notifier).removeProduct(
                                  rowData.data.CodigoMaterial.toString(),
                                );
                          },
                          icon: Icon(Icons.delete_forever),
                          color: Colors.red,
                        );
                      }),
                ],
              );

              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: DaviTheme(
                  child: Davi<Materiales>(model),
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
              child: Text('Enviar Guia'),
              onPressed: () async {
                ref.read(enviarGuiaProvider.notifier).enviarGuia(listadeitems);
                if (enviarGuiaState.isLoading) {
                  if (enviarGuiaState
                          .response?.soapresponseReturn.estadoComprobante ==
                      'FIRMADO') {
                    _generarNumeroFacturaDesdeHive();
                    //DISMINUCION DE STOCK EN LA BASE DE DATOS
                    for (var i = 0; i < widget.productos.length; i++) {
                      final product = widget.productos[i];
                      await updateStock(
                          int.parse(product.id.toString()),
                          int.parse(product.Cantidad.toString()),
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
        )
      ],
    );
    //dame un boton flotante
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
        name: widget.productos[i].MaterialUtilizado.toString(),
        qty: widget.productos[i].Cantidad.toString(),
        Codigo: widget.productos[i].id.toString(),
      ));
    }
    return details;
  }

  void insertarRegistroGuia(String Client, String direccion,
      List<Map<String, dynamic>> guianu, List<Materiales> productos) async {
    try {
      final detalleProductos = productos
          .map((product) => {
                'nombre': product.MaterialUtilizado,
                'cantidad': product.Cantidad,
                'codigo': product.CodigoMaterial,
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

import 'dart:convert';

import 'package:consugez_inventario/models/client.dart';
import 'package:consugez_inventario/models/materiales_obra.dart';
import 'package:consugez_inventario/models/ptoEmision.dart';
import 'package:consugez_inventario/providers/formfield.dart';
import 'package:consugez_inventario/widgets/Guia/clientSelection.dart';

import 'package:consugez_inventario/widgets/Guia/transportista%20conitnua.dart';
import 'package:consugez_inventario/widgets/Guia/ultimate_table_product_guia.dart';
import 'package:consugez_inventario/widgets/date2.dart';
import 'package:consugez_inventario/widgets/datewidget.dart';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class FacturaWidget extends ConsumerStatefulWidget {
  final List<Materiales> materialess;
  const FacturaWidget({Key? key, required this.materialess}) : super(key: key);

  @override
  _FacturaWidgetState createState() => _FacturaWidgetState();
}

final String? apiBaseUrl = dotenv.env['API_BASE_URL'];

class _FacturaWidgetState extends ConsumerState<FacturaWidget> {
  Cliente? selectedClient;

  void updateSelectedClient(Cliente cliente) {
    setState(() {
      selectedClient = cliente;
    });
  }

  Future<int> _obtenerUltimoNumeroFactura() async {
    //fetch info with Dio  for this link get api http://localhost:3000/api/factura/
    final response = await Dio().get('$apiBaseUrl/numeroguia');
    final data = PtoemisionResponce.fromJson(response.data);
    final ultimoNumeroFactura = data.facturaUltimo;
    return ultimoNumeroFactura;
  }

  _actualizarFactura(String Numeracion) async {
    final response = await Dio().put('$apiBaseUrl/numeroguia/', data: {
      "numero_factura": Numeracion,
    });
    print(response);
  }

  //
  //
  //
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
  //

  //control stock
  Future<void> updateStock(
      int productId, int stockChange, String operation) async {
    // Añadir la operación al objeto de datos
    final data = {
      'stockChange': stockChange,
      'operation': operation,
    };

    final response =
        await Dio().put('$apiBaseUrl/api/stock/$productId', data: data);

    print(data);
  }

  void initState() {
    super.initState();
    _generarNumeroTemporal();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final screenHeight = mediaQueryData.size.height;
    final screenWidth = mediaQueryData.size.width;
    final formsData = ref.read(formDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Completar Guia N-001-001-${formsData['secuencial']}',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            SizedBox(height: 10.0),
            Card(
                child: Padding(
                    padding: EdgeInsets.all(16.0), child: _buildInfoCliente())),
            SizedBox(height: 10.0),
            ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            content: CustomerSelectionWidget(
                                updateSelectedClient: updateSelectedClient));
                      });
                },
                child: Text(
                  'Clientes ',
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                )),
            SizedBox(height: 10.0),
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _Transportistaview(),
                Divider(),
                SizedBox(height: 5.0),
                Divider(),
                SizedBox(
                  height: mediaQueryData.size.height * 0.4,
                  child: TablaGuia(productos: widget.materialess),
                ),

                // _buildListaItems(),
                // _buildTotales(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCliente() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información del cliente: ${selectedClient?.ruc ?? ''}',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            'Nombre: ${selectedClient?.razonSocialComprador ?? ''}',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 8.0),
          Text(
            'Correo: ${selectedClient?.correo ?? ''}',
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            'Direccion: ${selectedClient?.dirreccionCliente ?? ''}',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }

  Widget _Transportistaview() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(children: [
        Datepickerinicio(labeltext: "Fecha Inicio Transporte:"),
        DatepickerFin(labeltext: "Fecha Fin Transporte:"),
        FormTransportista(),
      ]),
    );
  }

  getId() async {
    final box = await Hive.openBox('authBox');
    final idUser = box.get('userId');
    return idUser;
  }

  void enviarGuia(List<Map<String, dynamic>> detalles) async {
    final url = Uri.parse('http://localhost/apifacturacion/facturas.php');

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

  Widget Containerfactura(Text text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        width: 200,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                offset: Offset(0, 3), // changes position of shadow
              ),
            ]),
        child: Center(child: text),
      ),
    );
  }
}

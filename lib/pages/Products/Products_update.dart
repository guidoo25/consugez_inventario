import 'dart:convert';

import 'package:consugez_inventario/models/logs/update_product_model.dart';

import 'package:consugez_inventario/theme/enviroments.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductoUpdatelogs extends StatefulWidget {
  const ProductoUpdatelogs({
    Key? key,
  }) : super(key: key);

  @override
  _ProductoUpdatelogsState createState() => _ProductoUpdatelogsState();
}

class _ProductoUpdatelogsState extends State<ProductoUpdatelogs> {
  Future<List<Updateproducts>> getLogs() async {
    final response =
        await http.get(Uri.parse('${Enviroments.apiurl}/productos/updates'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Updateproducts.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener los materiales');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de transacciones'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Updateproducts>>(
              future: getLogs(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  DaviModel<Updateproducts> model = DaviModel<Updateproducts>(
                    rows: snapshot.data!,
                    columns: [
                      DaviColumn(
                        name: 'Articulo Ingresado',
                        stringValue: (data) => data.productName,
                      ),
                      DaviColumn(
                        name: 'Cantidad Aumentada',
                        stringValue: (data) => data.quantityAdded.toString(),
                      ),
                      DaviColumn(
                        name: 'Fecha de Ingreso',
                        stringValue: (data) => data.updateDate.toString(),
                      ),
                      DaviColumn(
                        name: 'Solicitante de la transaccion',
                        stringValue: (data) => data.userName,
                      ),
                    ],
                  );

                  return Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: DaviTheme(
                      child:
                          Davi<Updateproducts>(model, tapToSortEnabled: true),
                      data: DaviThemeData(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black12,
                          ),
                        ),
                        row: const RowThemeData(
                          dividerThickness: 4,
                          dividerColor: Colors.black12,
                        ),
                        header: HeaderThemeData(
                          color: Color.fromARGB(255, 255, 255, 255),
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
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return const CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}

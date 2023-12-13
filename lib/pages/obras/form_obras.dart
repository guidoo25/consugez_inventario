import 'dart:convert';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:consugez_inventario/models/client.dart';
import 'package:consugez_inventario/models/tabs/responsables.dart';
import 'package:consugez_inventario/pages/usuario_tabs/tabs/lsit_crud_users.dart';
import 'package:consugez_inventario/theme/enviroments.dart';
import 'package:consugez_inventario/widgets/Guia/clientSelection.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class FormObras extends ConsumerStatefulWidget {
  @override
  _FormObrasState createState() => _FormObrasState();
}

class _FormObrasState extends ConsumerState<FormObras> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nombreObraController = TextEditingController();
  TextEditingController fechaInicioController = TextEditingController();
  TextEditingController ubicacionController = TextEditingController();
  TextEditingController responsableController = TextEditingController();

  String? estadoAutorizacion;

  List<User> responsables = [];

  @override
  void initState() {
    super.initState();
    fechaInicioController.text =
        DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  Cliente? selectedClient;
  void updateSelectedClient(Cliente cliente) {
    setState(() {
      selectedClient = cliente;
    });
  }

  Future<List<User>> getUsers() async {
    try {
      final response = await http.get(Uri.parse('${Enviroments.apiurl}/users'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        List<User> users = data.map((item) => User.fromJson(item)).toList();
        return users;
      } else {
        throw Exception('Failed to load users');
      }
    } catch (error) {
      print(error);
      throw Exception('Error connecting to the server');
    }
  }

  Future<void> postObra() async {
    try {
      final url = Uri.parse('${Enviroments.apiurl}/obras');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'NombreObra': nombreObraController.text,
        'FechaInicio': fechaInicioController.text,
        'EstadoAutorizacion': "SINM",
        'Ubicacion': ubicacionController.text,
        'Responsable': responsableController.text,
        'cliente_id': selectedClient?.id,
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        // Show SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Obra creada correctamente'),
          ),
        );
      } else {
        throw Exception('Failed to post obra');
      }
    } catch (e) {
      throw Exception('Failed to post obra: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Obra'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<List<User>>(
          future: getUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              responsables = snapshot.data!;
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    Card(
                        child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: _buildInfoCliente())),
                    SizedBox(height: 10.0),
                    ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    content: CustomerSelectionWidget(
                                        updateSelectedClient:
                                            updateSelectedClient));
                              });
                        },
                        child: Text(
                          'Seleccionar Cliente ',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        )),
                    SizedBox(height: 15.0),
                    Divider(),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: nombreObraController,
                            decoration: InputDecoration(
                              labelText: 'Nombre Obra',
                              prefixIcon: Icon(Icons.work),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the obra name';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: TextFormField(
                            controller: fechaInicioController,
                            decoration: InputDecoration(
                              labelText: 'Fecha Inicio',
                              prefixIcon: Icon(Icons.calendar_today),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the fecha inicio';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: ubicacionController,
                            decoration: InputDecoration(
                              labelText: 'Ubicacion',
                              prefixIcon: Icon(Icons.location_on),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the ubicacion';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: CustomDropdown<String>(
                            closedBorder: Border.all(color: Colors.grey),
                            expandedBorder: Border.all(color: Colors.grey),
                            closedFillColor: Colors.white30,
                            hintText: 'Responsables',
                            items: responsables.map((e) => e.name).toList(),
                            initialItem: responsables[0].name,
                            onChanged: (value) {
                              responsableController.text = value;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          postObra();
                        }
                      },
                      child:
                          Text('Crear Obra', style: TextStyle(fontSize: 18.0)),
                    ),
                  ],
                ),
              );
            }
          },
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
}

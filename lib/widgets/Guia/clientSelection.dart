import 'dart:convert';

import 'package:consugez_inventario/models/client.dart';
import 'package:consugez_inventario/providers/clientprovider.dart';
import 'package:consugez_inventario/providers/formfield.dart';
import 'package:consugez_inventario/theme/enviroments.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class CustomerSelectionWidget extends ConsumerStatefulWidget {
  final Function(Cliente) updateSelectedClient;

  const CustomerSelectionWidget({required this.updateSelectedClient});
  @override
  _CustomerSelectionWidgetState createState() =>
      _CustomerSelectionWidgetState();
}

final String? apiBaseUrl = Enviroments.apiurl;

class _CustomerSelectionWidgetState
    extends ConsumerState<CustomerSelectionWidget> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _rucController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  Cliente? selectedClient;

  List<Cliente> clientes =
      []; // Reemplace Cliente con el nombre de su modelo de cliente
  void updateSelectedClient(Cliente cliente) {
    setState(() {
      selectedClient = cliente;
      // Actualiza el cliente seleccionado en el proveedor de formulario
    });
  }

  void _fetchCliente() async {
    final response = await http.get(Uri.parse('$apiBaseUrl/cliente'));
    if (response.statusCode == 200) {
      setState(() {
        clientes = clienteResponseFromJson(response.body).clientes;
      });
    } else {
      throw Exception('Failed to fetch customers');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCliente();
  }

  void _filterClientes(String query) {
    if (query.isNotEmpty) {
      List<Cliente> filteredClientes = [];
      clientes.forEach((cliente) {
        if (cliente.ruc.contains(query)) {
          filteredClientes.add(cliente);
        }
      });
      setState(() {
        clientes = filteredClientes;
      });
    } else {
      _fetchCliente();
    }
  }

  Future<Map<String, dynamic>> _createCustomer(String razonsocial,
      String rucliente, String correo, String dirreccionComprador) async {
    final response = await http.post(Uri.parse('$apiBaseUrl/cliente/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'rucliente': rucliente,
          'razonSocialComprador': razonsocial,
          'correo': correo,
          'direccionComprador': dirreccionComprador,
          'userid': '28',
        }));
    print(response.body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create customer');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: mediaQuery.size.height -
                mediaQuery.padding.top -
                mediaQuery.padding.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final Cliente? clienteSeleccionado =
                        await showDialog<Cliente>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Seleccione el Cliente'),
                          content: Column(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  width: double.maxFinite,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: clientes.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final cliente = clientes[index];
                                      return ListTile(
                                        title:
                                            Text(cliente.razonSocialComprador),
                                        subtitle: Text(cliente.ruc),
                                        onTap: () {
                                          widget.updateSelectedClient(cliente);
                                          ref
                                              .watch(clientProvider.notifier)
                                              .selectClient(cliente);
                                          Navigator.of(context).pop(cliente);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Text('Buscar Cliente'),
                ),
                SizedBox(height: 16.0),
                if (selectedClient != null)
                  Text(
                      'Cliente seleccionado: ${selectedClient!.razonSocialComprador} (${selectedClient!.ruc})'),
                Text(
                  'Crear cliente:',
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextFormField(
                  controller: _rucController,
                  onChanged: (value) {
                    _filterClientes(value);
                  },
                  decoration: InputDecoration(
                    labelText: 'RUC',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 13,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Correo',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 60,
                  keyboardType: TextInputType
                      .emailAddress, // Define el teclado como un teclado de correo electrónico
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                        RegExp('[\\s]') // deniega espacios en blanco
                        ),
                    LengthLimitingTextInputFormatter(
                        900), // Establece una longitud máxima de 50 caracteres
                  ],
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Direccion',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    final String nombre = _nameController.text.trim();
                    final String ruc = _rucController.text.trim();
                    final String correo = _addressController.text.trim();
                    final String direccion = _phoneController.text.trim();

                    final Cliente nuevoCliente = Cliente(
                      correo: correo,
                      dirreccionCliente: direccion,
                      ruc: ruc,
                      razonSocialComprador: nombre,
                      id: 28,
                    );
                    widget.updateSelectedClient(nuevoCliente);
                    // ref.watch(clientProvider.notifier).selectClient(nuevoCliente);
                    _createCustomer(nombre, ruc, correo, direccion);

                    _fetchCliente();
                    Navigator.of(context).pop(nuevoCliente);
                  },
                  child: Text('Crear Nuevo Cliente'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _BotonCientes() {
    return ElevatedButton(
      onPressed: () async {
        final Cliente? clienteSeleccionado = await showDialog<Cliente>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Seleccione el Cliente'),
              content: Container(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: clientes.length,
                  itemBuilder: (BuildContext context, int index) {
                    final cliente = clientes[index];
                    return ListTile(
                      title: Text(cliente.razonSocialComprador),
                      subtitle: Text(cliente.ruc),
                      onTap: () {
                        widget.updateSelectedClient(
                            cliente); // Actualiza el cliente seleccionado en el widget principal
                        Navigator.of(context).pop(cliente);
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      },
      child: Text('Seleccionar Cliente'),
    );
  }
}

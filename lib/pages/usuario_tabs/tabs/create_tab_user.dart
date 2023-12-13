import 'dart:convert';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:consugez_inventario/theme/enviroments.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegistroForm extends StatefulWidget {
  @override
  _RegistroFormState createState() => _RegistroFormState();
}

class _RegistroFormState extends State<RegistroForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rolescontroller = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _rolescontroller.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final email = _emailController.text;
      final password = _passwordController.text;
      final roles = _rolescontroller.text;

      final uri = Uri.parse('${Enviroments.apiurl}/registrar');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'role': roles,
        }),
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Éxito'),
            content: Text('Usuario registrado exitosamente'),
            actions: [
              TextButton(
                child: Text('Aceptar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      } else {
        // Maneja el error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Usuario'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa un email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa una contraseña';
                  }
                  return null;
                },
              ),
              CustomDropdown<String>(
                closedBorder: Border.all(color: Colors.grey),
                expandedBorder: Border.all(color: Colors.grey),
                closedFillColor: Colors.white30,
                hintText: "Seleccionar un Rol",
                items: ['Operador', 'Administrador', 'bodega'],
                onChanged: (value) {
                  if (value == 'Operador') {
                    _rolescontroller.text = '555';
                  }
                  if (value == 'administrador') {
                    _rolescontroller.text = '777';
                  }
                  if (value == 'bodega') {
                    _rolescontroller.text = '888';
                  }
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Registrar'),
              ),
            ],
            //dame un dropdownbutton con solo 2 opcioens operador que es con un valor de 555 y admin 777
          ),
        ),
      ),
    );
  }
}

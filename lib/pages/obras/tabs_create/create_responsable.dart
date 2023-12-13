import 'package:consugez_inventario/models/tabs/responsables.dart';
import 'package:consugez_inventario/theme/enviroments.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CreateResponsableScreen extends StatefulWidget {
  @override
  _CreateResponsableScreenState createState() =>
      _CreateResponsableScreenState();
}

class _CreateResponsableScreenState extends State<CreateResponsableScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  List<String> responsables = [];
  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final nombre = _nombreController.text;
      final email = _emailController.text;
      final telefono = _telefonoController.text;

      final url = '${Enviroments.apiurl}/encargado';

      try {
        final response = await Dio().post(
          url,
          data: {
            'nombre': nombre.toString(),
            'email': email.toString(),
            'telefono': telefono.toString(),
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Persona creada correctamente'),
          ),
        );
      } catch (e) {
        if (e is DioError) {
          print("Error message: ${e.response?.data}");
        } else {
          print("Unexpected error: $e");
        }
      }
    }
  }

  Future<void> _getResponsables() async {
    final url = '${Enviroments.apiurl}/encargado';

    try {
      final response = await Dio().get(url);
      final jsonreposnse = response.data;
      final responsablesResponseList =
          responsablesResponseFromJson(jsonreposnse);
      setState(() {
        responsables = responsablesResponseList
            .map((responsable) => responsable.nombre)
            .toList();
      });
    } catch (e) {
      if (e is DioError) {
        print("Error message: ${e.response?.data}");
      } else {
        print("Unexpected error: $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getResponsables();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Encargado'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                  hintText: 'Ingrese un nombre',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  hintText: 'Ingrese un email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _telefonoController,
                decoration: InputDecoration(
                  labelText: 'Telefono',
                  border: OutlineInputBorder(),
                  hintText: 'Ingrese un telefono',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un telefono';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Create'),
              ),
              SizedBox(height: 16.0),
              Text('Responsables:'),
              ListView.builder(
                shrinkWrap: true,
                itemCount: responsables.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(responsables[index]),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

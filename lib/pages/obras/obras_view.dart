import 'package:consugez_inventario/models/obras_model.dart';
import 'package:consugez_inventario/pages/obras/tabs_create/asignar_mats.dart';
import 'package:consugez_inventario/pages/obras/tabs_create/tablas_obras_aumento.dart';
import 'package:consugez_inventario/providers/obras_fetch.dart';
import 'package:consugez_inventario/theme/enviroments.dart';

import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ObrasScreen extends ConsumerStatefulWidget {
  @override
  _GuiaDetailsScreenState createState() => _GuiaDetailsScreenState();
}

class _GuiaDetailsScreenState extends ConsumerState<ObrasScreen> {
  String roles = "";
  String solicitantes = "";

  getRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role');
    final solicitante = prefs.getString('sol');
    if (role != null) {
      setState(() {
        roles = role;
        solicitantes = solicitante!;
      });
    }
    return role;
  }

  Future<void> DeleteObra(int id) async {
    final response = await http.delete(
        Uri.parse('${Enviroments.apiurl}/obras/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      print("Obra eliminada");
      setState(() {
        ref.read(obraProviderFetch.notifier).fetchObras();
      });
    } else {
      throw Exception('Error al eliminar la obra');
    }
  }

  @override
  void initState() {
    super.initState();
    getRole();
    ref.read(obraProviderFetch.notifier).fetchObras();
  }

  @override
  Widget build(BuildContext context) {
    final obras = ref.watch(obraProviderFetch);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial Obras'),
      ),
      body: ListView.builder(
        itemCount: obras.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
            child: ExpansionTile(
              backgroundColor: Colors.white,
              childrenPadding: const EdgeInsets.all(10),
              title: Container(
                padding: const EdgeInsets.all(10),
                child: Row(children: [
                  Text(
                    "Nombre de Obra:${obras[index].nombreObra}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  if (obras[index].estadoAutorizacion == "SINM" &&
                      roles == "555")
                    Submenu1(obras[index], roles, solicitantes),
                  if (obras[index].estadoAutorizacion == "ENPR")
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        color: Colors.yellow[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "En Proceso de Autorizacion Aumento",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  if (obras[index].estadoAutorizacion == "SGUI")
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        color: const Color.fromARGB(255, 157, 255, 247),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "En Proceso de Autorizacion Guia",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  if (roles == "777")
                    Aminmenu(obras[index], roles, solicitantes),
                  if (obras[index].estadoAutorizacion == "APR" &&
                      roles == "555")
                    Submenu2(obras[index], roles, solicitantes),
                ]),
              ),
              children: [
                ListTile(
                  title: Text('Cliente: ${obras[index].razonSocialComprador}'),
                ),
                const Divider(),
                const Text(
                  "",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ListTile(
                  title: Text('Ruc: ${obras[index].rucliente}'),
                  subtitle: Text(
                      'Encargado: ${obras[index].responsable}, FechaInicio: ${obras[index].fechaInicio}'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget Submenu1(Obra obras, String role, String solicitante) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: const Icon(
          Icons.list,
          size: 46,
          color: Colors.blueGrey,
        ),
        dropdownStyleData: DropdownStyleData(
            width: 160,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            )),
        items: [
          if (obras.estadoAutorizacion == "SINM" ||
              obras.estadoAutorizacion == "ASG")
            DropdownMenuItem(
              child: Text("Asignar Materiales"),
              value: 1,
            ),
          DropdownMenuItem(
            child: Text("Aumentar Materiales"),
            value: 2,
          ),
          DropdownMenuItem(
            child: Text("Solicitar Guia"),
            value: 3,
          )
        ],
        onChanged: (value) {
          switch (value) {
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AsignarMatsPage(obra: obras),
                ),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TablasObrasAumento(
                    solicitante: solicitante,
                    idObra: obras,
                    role: role,
                  ),
                ),
              );
            case 3:
              ChangeStatusGuia(obras.id);
              break;
          }
        },
      ),
    );
  }

  Widget Submenu2(Obra obras, String role, String solicitante) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: const Icon(
          Icons.list,
          size: 46,
          color: Colors.blueGrey,
        ),
        dropdownStyleData: DropdownStyleData(
            width: 160,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            )),
        items: [
          DropdownMenuItem(
            child: Text("Asignar otros materiales"),
            value: 1,
          ),
          DropdownMenuItem(
            child: Text("Solicitar Guia"),
            value: 2,
          ),
          DropdownMenuItem(
            child: Text("Aumentar Materiales"),
            value: 3,
          ),
        ],
        onChanged: (value) {
          switch (value) {
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AsignarMatsPage(obra: obras),
                ),
              );
              break;
            case 2:
              ChangeStatusGuia(obras.id);
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TablasObrasAumento(
                    idObra: obras,
                    role: role,
                    solicitante: solicitante,
                  ),
                ),
              );
          }
        },
      ),
    );
  }

  Widget Aminmenu(Obra obras, String role, String solicitante) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: const Icon(
          Icons.list,
          size: 46,
          color: Colors.blueGrey,
        ),
        dropdownStyleData: DropdownStyleData(
            width: 160,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            )),
        items: [
          DropdownMenuItem(
            child: Text("Asignar Materiales"),
            value: 1,
          ),
          DropdownMenuItem(
            child: Text("Eliminar obra"),
            value: 2,
          ),
          DropdownMenuItem(
            child: Text("Aumentar Materiales"),
            value: 3,
          ),
          if (obras.estadoAutorizacion == "SGUI")
            DropdownMenuItem(child: Text("Aprobar Guia"), value: 4),
        ],
        onChanged: (value) {
          switch (value) {
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AsignarMatsPage(obra: obras),
                ),
              );
              break;
            case 2:
              DeleteObra(obras.id);
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TablasObrasAumento(
                    idObra: obras,
                    role: role,
                    solicitante: solicitante,
                  ),
                ),
              );
              break;
            case 4:
              ChangeStatusGuiaAprrobe(obras.id);
          }
        },
      ),
    );
  }

  Future<void> ChangeStatusGuia(int id) async {
    final response = await http.put(
        Uri.parse('${Enviroments.apiurl}/obras/$id/statusguia'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      print("Solicitud Enviada ");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Solicitud Enviada')),
      );
    } else {
      throw Exception('Error al eliminar la obra');
    }
  }

  Future<void> ChangeStatusGuiaAprrobe(int id) async {
    final response = await http.put(
        Uri.parse('${Enviroments.apiurl}/obras/$id/statusguiaA'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      print("Solicitud Enviada ");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Solicitud Enviada')),
      );
    } else {
      throw Exception('Error al eliminar la obra');
    }
  }
}

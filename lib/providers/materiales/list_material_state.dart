import 'package:consugez_inventario/theme/enviroments.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:consugez_inventario/models/materiales_obra.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MaterialesNotifier extends StateNotifier<List<Materiales>> {
  MaterialesNotifier() : super([]);

  void setMateriales(List<Materiales> materiales) {
    state = materiales;
  }

  void addMateriales(Materiales materiales) {
    state = List.from(state)..add(materiales);
  }

  void removeMateriales(String id) {
    state = List.from(state)..removeWhere((materiales) => materiales.id == id);
  }

  void updateMateriales(Materiales materiales) {
    state = [
      for (final item in state)
        if (item.id == materiales.id) materiales else item
    ];
  }

  Future<List<Materiales>> getMateriales(int idObra) async {
    final response = await http
        .get(Uri.parse('${Enviroments.apiurl}/obras/$idObra/materiales'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['materiales'];

      state = jsonResponse
          .map((item) => Materiales.fromJson(item))
          .toList()
          .cast<Materiales>();
      return jsonResponse.map((item) => Materiales.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener los materiales');
    }
  }
}

final materialesProvider =
    StateNotifierProvider<MaterialesNotifier, List<Materiales>>(
        (ref) => MaterialesNotifier());

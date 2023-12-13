
import 'package:flutter_riverpod/flutter_riverpod.dart';


class FormData extends StateNotifier<Map<String, String>> {
  FormData() : super({
    'direccion': '',
    'transportista': '',
    'ruc': '',
    'placa': '',
    'motivo': '',
    'fechainicio': '',
    'fechafin': '',
    'cliente': '',
    'secuencial': '',
  });


  void updateValue(String field, String value) {
    state = {...state, field: value};
  }
}
final formDataProvider = StateNotifierProvider<FormData, Map<String, String>>((ref) => FormData());

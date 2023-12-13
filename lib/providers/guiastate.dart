import 'dart:convert';

import 'package:consugez_inventario/models/soap.dart';
import 'package:consugez_inventario/theme/enviroments.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final enviarGuiaProvider = StateNotifierProvider<EnviarGuiaNotifier, EnviarGuiaState>((ref) => EnviarGuiaNotifier());

class EnviarGuiaNotifier extends StateNotifier<EnviarGuiaState> {
  EnviarGuiaNotifier() : super(EnviarGuiaState());

  Future<void> enviarGuia(List<Map<String, dynamic>> detalles) async {
    state = EnviarGuiaState.loading();

    final url = Uri.parse('${Enviroments.apiphp}/guiaremision.php');

    // Convierte la lista de detalles a JSON
    final detallesJson = jsonEncode(detalles);
    print(detallesJson);

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type':  'application/x-www-form-urlencoded',
      },
      body: detallesJson,
    );

    if (response.statusCode == 200) {
      print(response.body);
      state = EnviarGuiaState.success(response.body);

    } else {
      state = EnviarGuiaState.error('Error: ${response.statusCode}');
    }
  }
}

class EnviarGuiaState {
  final bool isLoading;
  final String? errorMessage;
  final Soapresponse? response;

  EnviarGuiaState({
    this.isLoading = false,
    this.errorMessage,
    this.response,
  });

  factory EnviarGuiaState.loading() => EnviarGuiaState(isLoading: true);

  factory EnviarGuiaState.success(String response) => EnviarGuiaState(response: Soapresponse.fromJson(jsonDecode(response)));

  factory EnviarGuiaState.error(String errorMessage) => EnviarGuiaState(errorMessage: errorMessage);
}
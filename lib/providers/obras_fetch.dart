import 'package:consugez_inventario/models/obras_model.dart';
import 'package:consugez_inventario/theme/enviroments.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final obraProviderFetch =
    StateNotifierProvider<ObraNotifier, List<Obra>>((ref) {
  return ObraNotifier();
});

class ObraNotifier extends StateNotifier<List<Obra>> {
  ObraNotifier() : super([]);

  final Dio dio = Dio(BaseOptions(baseUrl: '${Enviroments.apiurl}/'));

  Future<void> fetchObras() async {
    try {
      final response = await dio.get('obras');
      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final obraResponse = ObrasReponse.fromJson(jsonResponse);
        state = obraResponse.obras;
        print(state);
      } else {
        throw Exception('Failed to load obras');
      }
    } catch (e) {
      throw Exception('Failed to load obras: $e');
    }
  }
}

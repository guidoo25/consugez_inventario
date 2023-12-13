import 'dart:convert';

import 'package:consugez_inventario/models/auth/response_atuh_model.dart';
import 'package:consugez_inventario/theme/enviroments.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthState {
  AuthState({required this.autenticando});

  bool autenticando;
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(autenticando: false));

  Future<bool> login(String email, String password) async {
    state = AuthState(autenticando: true);

    final data = {
      'email': email,
      'password': password,
    };

    final uri = Uri.parse('${Enviroments.apiurl}/auth');
    final resp = await http.post(
      uri,
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    state = AuthState(autenticando: false);

    if (resp.statusCode == 200) {
      final loginResponse = authReponseFromJson(resp.body);

      await this._guardarToken(loginResponse.rol, loginResponse.nombre);

      return true;
    } else {
      return false;
    }
  }

  Future<void> _guardarToken(String role, String solicitante) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', role);
    await prefs.setString('sol', solicitante);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

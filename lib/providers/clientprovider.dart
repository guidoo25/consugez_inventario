
import 'package:consugez_inventario/models/client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ClientProvider extends StateNotifier<Cliente?> {
  ClientProvider() : super(null);

  void selectClient(Cliente client) {
    state = client;
  }
}

final clientProvider = StateNotifierProvider<ClientProvider, Cliente?>((ref) => ClientProvider());
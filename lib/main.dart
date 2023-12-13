import 'package:consugez_inventario/routes/approute.dart';
import 'package:consugez_inventario/theme/enviroments.dart';
import 'package:consugez_inventario/theme/them_app..dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  await Enviroments().initEnviroments();
  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
    );
  }
}

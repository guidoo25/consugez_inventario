import 'package:consugez_inventario/models/obras_model.dart';
import 'package:consugez_inventario/pages/Davi_table_asignarmats.dart';
import 'package:consugez_inventario/providers/product_state.dart';
import 'package:consugez_inventario/widgets/formsShared/tabla_sin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsignarMatsPage extends ConsumerStatefulWidget {
  final Obra obra;

  const AsignarMatsPage({super.key, required this.obra});
  @override
  _AsignarMatsPageState createState() => _AsignarMatsPageState();
}

class _AsignarMatsPageState extends ConsumerState<AsignarMatsPage> {
  @override
  Widget build(BuildContext context) {
    final productos = ref.watch(productProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Asignar Materiales a obra ID:${widget.obra.id}'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: TablaAsignarMats(productos: productos, obra: widget.obra),
            )

            // Botón para retroceder a la pantalla anterior
          ],
        ),
      ),
    );
  }
}

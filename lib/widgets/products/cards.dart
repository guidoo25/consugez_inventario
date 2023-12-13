import 'package:consugez_inventario/models/update.dart';
import 'package:flutter/material.dart';

class StockUpdatesLogList extends StatelessWidget {
  final List<StockUpdatesLog> stockUpdatesLog;

  const StockUpdatesLogList({Key? key, required this.stockUpdatesLog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Salidas de producto'),
        centerTitle: true,
        backgroundColor: Colors.black26,
      ),
      body: Padding(
        padding: const EdgeInsets.all(9.0),
        child: ListView.builder(
          itemCount: stockUpdatesLog.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(9.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nombre: ${stockUpdatesLog[index].productName}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Producto ID: ${stockUpdatesLog[index].productId}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Stock anterior: ${stockUpdatesLog[index].previousStock}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Nuevo stock: ${stockUpdatesLog[index].newStock}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Cliente: ${stockUpdatesLog[index].clienteName}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Fecha de Salida: ${stockUpdatesLog[index].updateTime}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),

    );
  }
}
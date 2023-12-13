import 'package:consugez_inventario/providers/product_fetch.dart';
import 'package:consugez_inventario/widgets/products/cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductLists extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(productProviderfetch.notifier).fetchProducts();

    final products = ref.watch(productProviderfetch);




    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('${products[index].name}'),
          subtitle: Text('Codigo: ${products[index].category}'),
          trailing: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // ref.read(productProviderfetch.notifier).removeProduct(products[index].category!);
            },
          ),
          onTap: () async {
            final stockUpdatesLog = await ref.read(productProviderUpdate.notifier).fetchProductById((products[index].id.toString()));
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StockUpdatesLogList(stockUpdatesLog: stockUpdatesLog)),
            );
          },
        );
      },
    );
  }
}
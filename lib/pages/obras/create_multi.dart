import 'package:consugez_inventario/pages/obras/form_obras.dart';
import 'package:consugez_inventario/pages/obras/tabs_create/create_responsable.dart';
import 'package:consugez_inventario/pages/obras/tabs_create/materiales_create.dart';
import 'package:consugez_inventario/pages/xls_imp/import_products_xls.dart';
import 'package:flutter/material.dart';

class CreateMultiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: DefaultTabController(
        length: 2, // Replace 3 with the number of tabs you want
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Obras'),
                Tab(text: 'Materiales'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Container(
                    child: Center(
                      child: FormObras(),
                    ),
                  ),
                  // Replace these with your tab views

                  Container(
                    child: Center(
                      child: CreateProductScreen(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:consugez_inventario/pages/usuario_tabs/tabs/Crud_view_usarios.dart';
import 'package:consugez_inventario/pages/usuario_tabs/tabs/create_tab_user.dart';
import 'package:flutter/material.dart';

class CreateUsuarios extends StatelessWidget {
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
                Tab(text: 'Crear Usuarios'),
                Tab(text: 'lista de Usuarios'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Container(
                    child: Center(
                      child: RegistroForm(),
                    ),
                  ),
                  // Replace these with your tab views
                  Container(
                    child: Center(
                      child: UserListView(),
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

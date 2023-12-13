import 'package:consugez_inventario/pages/Guia_state.dart';
import 'package:consugez_inventario/pages/Products/Product_view.dart';
import 'package:consugez_inventario/pages/Products/admin_panel.dart';
import 'package:consugez_inventario/pages/obras/create_multi.dart';
import 'package:consugez_inventario/pages/obras/obras_view.dart';
import 'package:consugez_inventario/pages/usuario_tabs/create_usuarios_screen.dart';

import 'package:consugez_inventario/widgets/Guia/emisor.dart';
//import 'package:consugez_inventario/widgets/products/card_product.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String roles = "";
  @override
  void initState() {
    super.initState();
    getRole();
  }

  getRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role');
    if (role != null) {
      setState(() {
        roles = role;
      });
    }
    return role;
  }

  int _selectedIndex = 0;
  final widgetOptions = [
    const DesktopScaffold(),
    //FacturaWidget(),
    //ProductLists(),
    ObrasScreen(),
    CreateMultiPage(),
    CreateUsuarios(),
    ProductView(),
  ];
  final bodegaOptions = [
    ProductView(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.selected,
            backgroundColor: Colors.black12,
            destinations: [
              const NavigationRailDestination(
                icon: Icon(Icons.home_filled),
                label: Text('Inicio'),
              ),
              const NavigationRailDestination(
                icon: Icon(Icons.build_circle_outlined),
                selectedIcon: Icon(Icons.build_circle_rounded),
                label: Text(' Gestion Obras'),
              ),
              const NavigationRailDestination(
                icon: Icon(Icons.create),
                selectedIcon: Icon(Icons.create_sharp),
                label: Text('Crear '),
              ),
              if (roles == "777")
                const NavigationRailDestination(
                  icon: Icon(Icons.supervised_user_circle_outlined),
                  selectedIcon: Icon(Icons.supervised_user_circle_rounded),
                  label: Text('Gestion de Usuarios '),
                ),
              if (roles == "777")
                const NavigationRailDestination(
                  icon: Icon(Icons.list_sharp),
                  selectedIcon: Icon(Icons.line_style),
                  label: Text('Gestion Articulos'),
                ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: roles == "888"
                ? bodegaOptions.elementAt(_selectedIndex)
                : widgetOptions.elementAt(_selectedIndex),
          ),
        ],
      ),
    );
  }
}

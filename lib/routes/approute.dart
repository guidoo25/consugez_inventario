import 'package:consugez_inventario/pages/home_page.dart';
import 'package:consugez_inventario/pages/login_page.dart';
import 'package:consugez_inventario/widgets/Guia/ProductList.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(initialLocation: '/Login', routes: [
  GoRoute(
    path: '/home',
    name: 'home',
    builder: (context, state) => HomeScreen(),
  ),
  GoRoute(
    path: '/Login',
    name: 'Login',
    builder: (context, state) => LoginPage(),
  ),
  GoRoute(
    path: "/ListProduct",
    name: 'listPorudct',
    builder: (context, state) => ProductList(),
  ),
]);

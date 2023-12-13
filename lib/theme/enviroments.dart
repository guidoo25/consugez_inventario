

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Enviroments {
  initEnviroments() async {
    await dotenv.load(fileName: ".env");
  }

  static String apiurl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/api';
  static String apiphp = dotenv.env['API_PHP'] ?? 'http://localhost:3000/apifacturacion';

}
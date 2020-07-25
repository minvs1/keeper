import 'package:fluro/fluro.dart';
import 'package:keeper/config/route_handlers.dart';

class Routes {
  static void configureRoutes(Router router) {
    router.define('/', handler: newSecretHandler);
    router.define('/secrets', handler: indexSecretHandler);
  }
}

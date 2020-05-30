import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:keeper/widgets/home.dart';

class Routes {
  static void configureRoutes(Router router) {
    router.define(
      '/',
      handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          return Home();
        },
      ),
    );
  }
}

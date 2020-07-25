import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:keeper/widgets/secret/secret.dart';

var indexSecretHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return ShowSecret();
  },
);

var newSecretHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return NewSecret();
  },
);

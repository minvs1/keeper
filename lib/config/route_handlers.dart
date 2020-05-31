import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:keeper/widgets/secret/secret.dart';

var newSecretHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return NewSecret();
  },
);

var showSecretHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return ShowSecret();
  },
);

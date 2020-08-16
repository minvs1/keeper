import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:keeper/repositories/abstract_repository.dart';

class SecretNotFound implements Exception {
  String cause;

  SecretNotFound(this.cause);
}

class HttpRepository implements AbstractRepository {
  final String url;

  HttpRepository({@required this.url}) : assert(url != null);

  Future<String> getSecret(String id) async {
    final response = await http.post(
      "${this.url}/get",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'id': id}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['encrypted_secret'];
    } else if (response.statusCode == 404) {
      throw SecretNotFound('No secret with such ID');
    }

    throw Exception('Unknown error');
  }

  Future<String> setSecret(String encryptedSecret) async {
    final response = await http.post(
      "${this.url}/add",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'encrypted_secret': encryptedSecret}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['id'];
    }

    throw Exception('Unknown error');
  }
}

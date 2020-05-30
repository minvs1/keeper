import 'package:equatable/equatable.dart';
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';
import 'package:nanoid/non_secure/nanoid.dart';

class Secret extends Equatable {
  final String id;
  final String unencryptedSecret;
  final String encryptedSecret;
  final String password;

  Secret({
    this.id = '',
    this.unencryptedSecret = '',
    this.encryptedSecret = '',
    String password,
  }) : this.password = password ?? nanoid(12);

  Secret copyWith(
      {String id,
      String unencryptedSecret,
      String encryptedSecret,
      String password}) {
    return Secret(
      id: id ?? this.id,
      unencryptedSecret: unencryptedSecret ?? this.unencryptedSecret,
      encryptedSecret: id ?? this.encryptedSecret,
      password: id ?? this.password,
    );
  }

  @override
  List<Object> get props => [id, unencryptedSecret, encryptedSecret, password];

  @override
  String toString() {
    return 'Secret { id: $id, unencryptedSecret: $unencryptedSecret, encryptedSecret: $encryptedSecret, password: $password }';
  }

  String toEncryptedString() {
    // TODO: return error if missing
    return _encryptString();
  }

  String toUnencryptedString() {
    // TODO: return error if missing
    return _decryptString();
  }

  String _encryptString() {
    final iv = encrypt.IV.fromLength(16);

    return _getEncrypter().encrypt(unencryptedSecret, iv: iv).base64;
  }

  String _decryptString() {
    final iv = encrypt.IV.fromLength(16);

    return _getEncrypter()
        .decrypt(encrypt.Encrypted.fromBase64(encryptedSecret), iv: iv);
  }

  encrypt.Encrypter _getEncrypter() {
    final key = encrypt.Key.fromBase16(
      sha256.convert(utf8.encode(password)).toString(),
    );

    return encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.ctr));
  }
}

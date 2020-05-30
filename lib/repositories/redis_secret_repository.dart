import 'package:meta/meta.dart';
import 'package:dartis/dartis.dart' as redis;
import 'package:nanoid/nanoid.dart';

class RedisSecretRepository {
  static const _ID_PREFIX = 'id_';
  final String redisURL;
  redis.Client redisClient;

  RedisSecretRepository({@required this.redisURL}) : assert(redisURL != null);

  Future<String> getSecret(String id) async {
    final commands = await _openConnection();

    final encryptedSecret = await commands.get("$_ID_PREFIX$id");

    await _closeConnection();

    return encryptedSecret;
  }

  Future<String> setSecret(String encryptedSecret) async {
    final commands = await this._openConnection();

    // TODO: check if non-existante
    final id = nanoid(12);

    await commands.set(_id(id), encryptedSecret);

    await _closeConnection();

    return id;
  }

  Future<void> removeSecret(String id) async {
    final commands = await this._openConnection();
    await commands.del(key: _id(id));
  }

  Future<redis.Commands> _openConnection() async {
    this.redisClient = await redis.Client.connect(this.redisURL);
    return this.redisClient.asCommands<String, String>();
  }

  Future<void> _closeConnection() async {
    this.redisClient.disconnect();
  }

  _id(String id) {
    return "$_ID_PREFIX$id";
  }
}

abstract class AbstractRepository {
  Future<String> getSecret(String id);

  Future<String> setSecret(String encryptedSecret);
}

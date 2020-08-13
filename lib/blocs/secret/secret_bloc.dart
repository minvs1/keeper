import 'package:bloc/bloc.dart';
import 'package:keeper/blocs/secret/secret.dart';
import 'package:keeper/repositories/abstract_repository.dart';
import 'package:keeper/repositories/firebaseio_repository.dart';
import 'package:meta/meta.dart';

class SecretBloc extends Bloc<SecretEvent, SecretState> {
  final AbstractRepository secretRepository;

  SecretBloc({@required this.secretRepository})
      : assert(secretRepository != null),
        super(SecretInitial());

  @override
  Stream<SecretState> mapEventToState(SecretEvent event) async* {
    if (event is SecretEncrypted) {
      yield* _mapSecretEncryptedToState(event);
    } else if (event is SecretDecrypted) {
      yield* _mapSecretDecryptedToState(event);
    }
  }

  Stream<SecretState> _mapSecretEncryptedToState(SecretEncrypted event) async* {
    yield SecretInProgress();
    try {
      final id = await _saveSecret(event.secret.toEncryptedString());
      final secret = event.secret.copyWith(id: id);
      yield SecretEncryptSuccess(secret);
    } catch (e) {
      yield SecretEncryptError();
    }
  }

  Stream<SecretState> _mapSecretDecryptedToState(SecretDecrypted event) async* {
    yield SecretInProgress();
    // TODO: validate secret and yield error state if invalid
    final secretID = event.secret.id.split("#");

    try {
      final encryptedSecret = await _fetchSecret(secretID[0]);
      final secret = event.secret
          .copyWith(encryptedSecret: encryptedSecret, password: secretID[1]);
      yield SecretDecryptSuccess(
          secret.copyWith(unencryptedSecret: secret.toUnencryptedString()));
    } on SecretNotFound catch (e) {
      yield SecretDecryptNotFound();
    } catch (e) {
      yield SecretDecryptError();
    }
  }

  Future<String> _saveSecret(String encryptedSecret) {
    return secretRepository.setSecret(encryptedSecret);
  }

  Future<String> _fetchSecret(String id) {
    return secretRepository.getSecret(id);
  }
}

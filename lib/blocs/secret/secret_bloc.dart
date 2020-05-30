import 'package:bloc/bloc.dart';
import 'package:keeper/blocs/secret/secret.dart';
import 'package:keeper/repositories/repositories.dart';
import 'package:meta/meta.dart';

class SecretBloc extends Bloc<SecretEvent, SecretState> {
  final RedisSecretRepository secretRepository;

  SecretBloc({@required this.secretRepository})
      : assert(secretRepository != null);

  @override
  SecretState get initialState => SecretInitial();

  @override
  Stream<SecretState> mapEventToState(SecretEvent event) async* {
    if (event is SecretEncrypted) {
      yield* _mapSecretAddedToState(event);
    }
  }

  Stream<SecretState> _mapSecretAddedToState(SecretEncrypted event) async* {
    yield SecretInProgress();
    final id = await _saveSecret(event.secret.toEncryptedString());
    final secret = event.secret.copyWith(id: id);
    yield SecretSuccess(secret);
  }

  Future<String> _saveSecret(String encryptedSecret) {
    return secretRepository.setSecret(encryptedSecret);
  }
}

import 'package:equatable/equatable.dart';
import 'package:keeper/models/models.dart';

abstract class SecretEvent extends Equatable {
  const SecretEvent();

  @override
  List<Object> get props => [];
}

class SecretEncrypted extends SecretEvent {
  final Secret secret;

  const SecretEncrypted(this.secret);

  @override
  List<Object> get props => [secret];

  @override
  String toString() => 'SecretEncrypted { secret: $secret }';
}

class SecretDecrypted extends SecretEvent {
  final Secret secret;

  const SecretDecrypted(this.secret);

  @override
  List<Object> get props => [secret];

  @override
  String toString() => 'SecretDecrypted { secret: $secret }';
}

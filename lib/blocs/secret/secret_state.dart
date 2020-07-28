import 'package:equatable/equatable.dart';
import 'package:keeper/models/models.dart';

abstract class SecretState extends Equatable {
  const SecretState();

  @override
  List<Object> get props => [];
}

class SecretInitial extends SecretState {}

class SecretInProgress extends SecretState {}

class SecretEncryptSuccess extends SecretState {
  final Secret secret;

  const SecretEncryptSuccess(this.secret);

  @override
  List<Object> get props => [secret];

  @override
  String toString() => 'SecretEncryptSuccess { secret: $secret }';
}

class SecretDecryptSuccess extends SecretState {
  final Secret secret;

  const SecretDecryptSuccess(this.secret);

  @override
  List<Object> get props => [secret];

  @override
  String toString() => 'SecretDecryptSuccess { secret: $secret }';
}

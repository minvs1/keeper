import 'package:equatable/equatable.dart';
import 'package:keeper/models/models.dart';

abstract class SecretState extends Equatable {
  const SecretState();

  @override
  List<Object> get props => [];
}

class SecretInitial extends SecretState {}

class SecretInProgress extends SecretState {}

class SecretSuccess extends SecretState {
  final Secret secret;

  const SecretSuccess(this.secret);

  @override
  List<Object> get props => [secret];

  @override
  String toString() => 'SecretSuccess { secret: $secret }';
}

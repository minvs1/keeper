import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:keeper/blocs/blocs.dart';
import 'package:meta/meta.dart';

abstract class RouterEvent extends Equatable {
  const RouterEvent();

  @override
  List<Object> get props => [];
}

class RouterNavigated extends RouterEvent {
  final BuildContext context;
  final String path;

  RouterNavigated(this.context, this.path);

  @override
  List<Object> get props => [];

  @override
  String toString() => 'RouterNavigated {}';
}

abstract class RouterState extends Equatable {
  const RouterState();

  @override
  List<Object> get props => [];
}

class RouterInitial extends RouterState {}

class RouterSuccess extends RouterState {
  final String path;

  const RouterSuccess(this.path);
}

class RouterBloc extends Bloc<RouterEvent, RouterState> {
  final Router router;

  RouterBloc({@required this.router})
      : assert(router != null),
        super(RouterInitial());

  @override
  Stream<RouterState> mapEventToState(RouterEvent event) async* {
    if (event is RouterNavigated) {}
  }
}

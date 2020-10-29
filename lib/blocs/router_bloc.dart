import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluro/fluro.dart' as fluro;
import 'package:flutter/material.dart';
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
  String toString() => 'RouterNavigated { path: $path }';
}

class RouterState extends Equatable {
  final String path;

  const RouterState({this.path = '/'});

  RouterState copyWith({String path}) {
    return RouterState(path: path ?? this.path);
  }

  @override
  List<Object> get props => [path];
}

class RouterBloc extends Bloc<RouterEvent, RouterState> {
  final fluro.Router router;

  RouterBloc({@required this.router})
      : assert(router != null),
        super(RouterState());

  @override
  Stream<RouterState> mapEventToState(RouterEvent event) async* {
    if (event is RouterNavigated) {
      router
          .navigateTo(
            event.context,
            event.path,
            transition: fluro.TransitionType.fadeIn,
          )
          .then((value) => Navigator.pop(event.context));

      yield RouterState(path: event.path);
    }
  }
}

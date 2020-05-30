import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluro/fluro.dart';
import 'package:meta/meta.dart';

abstract class RouterEvent extends Equatable {
  const RouterEvent();

  @override
  List<Object> get props => [];
}

class RouterNavigated extends RouterEvent {
  const RouterNavigated();

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

class RouterBloc extends Bloc<RouterEvent, RouterState> {
  final Router router;

  RouterBloc({@required this.router}) : assert(router != null);

  @override
  RouterState get initialState => RouterInitial();

  @override
  Stream<RouterState> mapEventToState(RouterEvent event) async* {
    if (event is RouterNavigated) {
      print("asdasd111");
    }
  }
}

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:keeper/config/app_config.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();
}

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

class AppInitial extends AppState {}

class AppBloc extends Bloc<AppEvent, dynamic> {
  final AppConfig appConfig;

  AppBloc({@required this.appConfig})
      : assert(appConfig != null),
        super(AppInitial());

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {}
}

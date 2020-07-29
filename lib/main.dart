import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:keeper/widgets/app.dart';
import 'package:keeper/widgets/keeper_observer.dart';

void main() {
  Bloc.observer = KeeperObserver();

  runApp(App());
}

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:keeper/widgets/app.dart';
import 'package:keeper/widgets/keeper_observer.dart';

void main() async {
  await DotEnv().load('.env');

  Bloc.observer = KeeperObserver();

  runApp(App());
}

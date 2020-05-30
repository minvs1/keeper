import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keeper/blocs/blocs.dart';

import 'package:keeper/config/app_config.dart';
import 'package:keeper/config/routes.dart';
import 'package:keeper/repositories/repositories.dart';

class App extends StatelessWidget {
  final appConfig = AppConfig();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final RedisSecretRepository secretRepository =
        RedisSecretRepository(redisURL: 'redis://localhost:6379');

    final router = Router();
    Routes.configureRoutes(router);

    return MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(
          create: (context) => AppBloc(appConfig: appConfig),
        ),
        BlocProvider<RouterBloc>(
          create: (context) => RouterBloc(router: router),
        ),
        BlocProvider<SecretBloc>(
          create: (context) => SecretBloc(secretRepository: secretRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        darkTheme: ThemeData(
          primaryColor: Colors.purple,
          accentColor: Colors.white,
          textSelectionColor: Colors.white24,
          brightness: Brightness.dark,
          backgroundColor: Color(0xFF121212),
          scaffoldBackgroundColor: Color(0xFF121212),
          cardColor: Color(0xFF121212),
          canvasColor: Color(0xFF121212),
          applyElevationOverlayColor: true,
          appBarTheme: AppBarTheme(
            color: Color(0xFF121212),
            elevation: 1.0,
          ),
        ),
        onGenerateRoute: BlocProvider.of<RouterBloc>(context).router.generator,
      ),
    );
  }
}

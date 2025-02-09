import 'package:fluro/fluro.dart' as fluro;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' as Foundation;

import 'package:keeper/blocs/blocs.dart';
import 'package:keeper/config/app_config.dart';
import 'package:keeper/config/routes.dart';
import 'package:keeper/repositories/http_repository.dart';

class App extends StatelessWidget {
  final appConfig = AppConfig();
  final httpURL = Foundation.kDebugMode
      ? 'http://localhost:5001/keeper-658e3/us-central1'
      : 'https://us-central1-keeper-658e3.cloudfunctions.net';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final HttpRepository secretRepository = HttpRepository(url: httpURL);

    final router = fluro.Router();
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
      child: Builder(
        builder: (context) => MaterialApp(
          title: 'Keeper',
          theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            primaryColor: Colors.indigo[700],
            accentColor: Colors.white,
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
          onGenerateRoute:
              BlocProvider.of<RouterBloc>(context).router.generator,
        ),
      ),
    );
  }
}

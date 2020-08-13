import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:keeper/blocs/blocs.dart';

import 'package:keeper/config/app_config.dart';
import 'package:keeper/config/routes.dart';
import 'package:keeper/repositories/firebaseio_repository.dart';
import 'package:keeper/repositories/repositories.dart';

class App extends StatelessWidget {
  final appConfig = AppConfig();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final FirebaseioRepository secretRepository = FirebaseioRepository(
        functionURL: DotEnv().env['FIREBASEIO_FUNCTION_URL']);

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

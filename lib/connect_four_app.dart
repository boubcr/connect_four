import 'package:connect_four/auth/auth.dart';
import 'package:connect_four/common/custom_audio_player.dart';
import 'package:connect_four/common/background_painter.dart';
import 'package:connect_four/game/screens/game_rules.dart';
import 'package:connect_four/game/screens/new_game.dart';
import 'package:connect_four/players/bloc/bloc.dart';
import 'package:connect_four/settings/screens/account_screen.dart';
import 'package:connect_four/settings/bloc/bloc.dart';
import 'package:connect_four/settings/screens/settings_home.dart';
import 'package:connect_four/common/loading_indicator.dart';
import 'package:connect_four/utils/utility.dart';
import 'package:connect_four/welcome/splash_screen.dart';
import 'package:connect_four/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connect_four/game/game.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:logging/logging.dart';
import 'game/game.dart';
import 'utils/routes.dart';
import 'package:game_manager/game_manager.dart';

import 'utils/transitions/transitions.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';

class ConnectFourApp extends StatefulWidget {
  ConnectFourApp({Key key}) : super(key: key);

  @override
  _ConnectFourAppState createState() => _ConnectFourAppState();
}

class _ConnectFourAppState extends State<ConnectFourApp> {
  static final _log = Logger('ConnectFourApp');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //TODO Add Firebase analysis

  // Beer-me up
  //static OptOutAwareFirebaseAnalytics analytics = OptOutAwareFirebaseAnalytics(FirebaseAnalytics());

  @override
  Widget build(BuildContext context) {
    // Set-up error reporting
    FlutterError.onError = (FlutterErrorDetails error) {
      //printException(error.exception, error.stack, error.context.toString());
      print('onError: $error');
    };

    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) =>
              LoginBloc(userRepository: FirebaseUserRepository()),
        ),
        BlocProvider<RegisterBloc>(
          create: (context) =>
              RegisterBloc(userRepository: FirebaseUserRepository()),
        ),
        BlocProvider<AuthBloc>(
          create: (context) =>
              AuthBloc(userRepository: FirebaseUserRepository())
                ..add(AppStarted()),
        ),
        BlocProvider<GamesBloc>(
          create: (context) => GamesBloc(
            gamesRepository: FirebaseGameRepository(
                playerRepository: FirebasePlayerRepository()),
            moveRepository: FirebaseMoveRepository(),
            authBloc: BlocProvider.of<AuthBloc>(context),
          ),
        ),
        BlocProvider<PlayersBloc>(
          create: (context) => PlayersBloc(
              gamesBloc: BlocProvider.of<GamesBloc>(context),
              repository: FirebasePlayerRepository())
            ..add(PlayersLoading()),
        ),
        BlocProvider<SettingsBloc>(
          create: (context) => SettingsBloc()..add(SettingsLoading()),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is LoadSuccess) {
            CustomAudioPlayer(sound: state.options.soundOn);
            return _buildMaterialApp(settings: state.options);
          }

          return LoadingIndicator();
        },
      ),
    );
  }

  Widget _buildMaterialApp({SettingsOption settings}) {
    Locale selectedLocale = Utility.getLocale(context, settings.language);
    context.locale = selectedLocale;

    _log.info(settings);

    return MaterialApp(
      theme: settings.theme.theme,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: selectedLocale,
      routes: {
        AppRoutes.home: (context) =>
            BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
              YYDialog.init(context);
              if (state is Uninitialized) {
                BackgroundSingleton(MediaQuery.of(context).size);
                return SplashScreen();
              }

              if (state is Unauthenticated) {
                return WelcomeScreen();
                //return LoginScreen(userRepository: FirebaseUserRepository());
              }

              if (state is Authenticated) {
                _log.info('Authenticated');
                _log.info('${state.user}');
                return GameHome();
              }

              _log.info('Loading');
              return LoadingIndicator();
            }),
      },
      onGenerateRoute: (RouteSettings settings) {
        _log.info('Route: ${settings.name}');
        switch (settings.name) {
          case AppRoutes.login:
            return ScaleRoute(page: LoginScreen());
          case AppRoutes.register:
            return ScaleRoute(page: RegisterScreen());
          case AppRoutes.newGame:
            return ScaleRoute(page: NewGameScreen(mode: settings.arguments));
          case AppRoutes.gameScreen:
            return ScaleRoute(page: GameScreen());
          case AppRoutes.settings:
            return ScaleRoute(page: SettingsHome());
          case AppRoutes.account:
            return ScaleRoute(page: AccountScreen());
          case AppRoutes.rules:
            return ScaleRoute(page: GameRules());
          default:
            return PageRouteBuilder(
                pageBuilder: (_, __, ___) => SplashScreen(),
                transitionsBuilder: (_, a, __, c) =>
                    FadeTransition(opacity: a, child: c));
        }
      },
    );
  }
}

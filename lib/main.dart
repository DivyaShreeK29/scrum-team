import 'package:flutter/material.dart';
import 'package:scrum_poker/pages/navigation/navigation_router.dart';
import 'package:scrum_poker/store/shared_preference.dart';
import 'package:scrum_poker/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) {
    print("Error from INSIDE FRAMEWORK");
    print("Error: ${details.exception}");
    print("StackTrace: ${details.stack}");
  };
  // setPathUrlStrategy();
  await initalizeSharedPreference();
  runApp(ScrumPoker());
}

class ScrumPoker extends StatelessWidget {
  final AppRouterDelegate _appRouterDelegate = AppRouterDelegate();
  final AppRouteInformationParser _appRouteInformationParser =
      AppRouteInformationParser();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        routeInformationParser: _appRouteInformationParser,
        routerDelegate: _appRouterDelegate,
        title: 'Scrum Poker',
        theme: appLightTheme,
        debugShowCheckedModeBanner: false);
  }
}

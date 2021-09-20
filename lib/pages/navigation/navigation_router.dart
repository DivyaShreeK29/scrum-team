import 'package:flutter/material.dart';
import 'package:scrum_poker/pages/navigation/navigation_util.dart';
import 'package:scrum_poker/pages/navigation/router_config.dart';

import '../scrum_session/scrum_session_page.dart';
import '../landing/landing_page.dart';
import '../page_not_found/page_not_found.dart';

var routerMap = {
  "/": (routerDelegate, pathParameters, queryParameters) =>
      LandingPage(routerDelegate: routerDelegate),
  "/home/:sessionId": (routerDelegate, pathParameters, queryParameters) =>
      ScrumSessionPage(id: pathParameters["sessionId"]),
  "/not-found": (routerDelegate, pathParameters, queryParameters) =>
      PageNotFound(),
};

///AppRoutePath is the state variable that holds the active Route and active Page
///
class AppRoutePath {
  final RouteConfig routeConfig;

  //initilize the app route Path
  AppRoutePath.pushRoute(this.routeConfig);
}

class NavigationRouter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NavigationRouterState();
}

class _NavigationRouterState extends State<NavigationRouter> {
  //initialize the empty state
  @override
  Widget build(BuildContext context) {
    AppRouterDelegate _appRouterDelegate = AppRouterDelegate();
    AppRouteInformationParser _appRouteInformationParser =
        AppRouteInformationParser();
    return MaterialApp.router(
      routeInformationParser: _appRouteInformationParser,
      routerDelegate: _appRouterDelegate,
    );
  }
}

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;
  String urlString = "";
  RouteConfig routeConfig;
  Widget? activePage;
  AppRouterDelegate()
      : navigatorKey = GlobalKey<NavigatorState>(),
        routeConfig = NavigationUtil.resolveRouteToWidget("/", routerMap);

  void pushRoute(String url) {
    this.routeConfig = NavigationUtil.resolveRouteToWidget(url, routerMap);
    this.activePage = this.routeConfig.getPage(this);
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    if (activePage == null) {
      this.activePage = this.routeConfig.getPage(this);
    }
    var page = MaterialPage(
        child: this.activePage!, key: ValueKey(activePage.toString()));
    return Navigator(
      key: navigatorKey,
      pages: [page],
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;

        notifyListeners();
        return true;
      },
    );
  }

  AppRoutePath get currentConfiguration {
    return AppRoutePath.pushRoute(this.routeConfig);
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    // TODO: implement setNewRoutePath
    print("Set new route path ${configuration.routeConfig.route}");
    //set the incoming route to reflect the incoming route
    this.urlString = configuration.routeConfig.route;
    return;
  }
}

class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    print(
        "AppRouteInformationParser parseRouteInformaton Called ${routeInformation.location!}");
    RouteConfig routeConfig = NavigationUtil.resolveRouteToWidget(
        routeInformation.location!, routerMap);
    var page = routeConfig.getPage(null);
    return AppRoutePath.pushRoute(routeConfig);
  }

  @override
  RouteInformation restoreRouteInformation(AppRoutePath configuration) {
    print("Restoring route information ${configuration.routeConfig.route} ");
    return RouteInformation(location: configuration.routeConfig.route);
  }
}
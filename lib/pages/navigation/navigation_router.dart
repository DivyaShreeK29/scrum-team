import 'package:flutter/material.dart';
import 'package:scrum_poker/pages/ExitSession/exit.dart';
import 'package:scrum_poker/pages/join_session_with_link/join_session_with_link.dart';
import 'package:scrum_poker/pages/navigation/navigation_util.dart';
import 'package:scrum_poker/pages/navigation/router_config.dart';

import '../scrum_session/scrum_session_page.dart';
import '../landing/landing_page.dart';
import '../page_not_found/page_not_found.dart';

var routerMap = {
  "/": (routerDelegate, pathParameters, queryParameters) =>
      LandingPage(routerDelegate: routerDelegate, onTap: () {}),
  "/join/:sessionId": (routerDelegate, pathParameter, queryParameters) =>
      JoinSessionFromLink(
          id: pathParameter["sessionId"], routerDelegate: routerDelegate),
  "/home/:sessionId": (routerDelegate, pathParameters, queryParameters) =>
      ScrumSessionPage(
        id: pathParameters["sessionId"],
        routerDelegate: routerDelegate,
      ),
  "/not-found": (routerDelegate, pathParameters, queryParameters) =>
      PageNotFound(),
  "/session-ended": (routerDelegate, pathParameters, queryParameters) =>
      ExitPage()
};

///AppRoutePath is the state variable that holds the active Route and active Page
///
class AppRoutePath {
  final RouteConfig routeConfig;

  //initilize the app route Path
  AppRoutePath(this.routeConfig);
}

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  late final GlobalKey<NavigatorState> navigatorKey;
  String urlString = "";
  late RouteConfig routeConfig;
  Widget? activePage;
  AppRouterDelegate() {
    navigatorKey = GlobalKey<NavigatorState>();
    routeConfig = NavigationUtil.resolveRouteToWidget("/", routerMap);
  }

  get navigator => null;

  void pushRoute(String url) {
    this.routeConfig = NavigationUtil.resolveRouteToWidget(url, routerMap);
    this.activePage = this.routeConfig.getPage(this);
    notifyListeners();
  }

  @override
  Future<bool> popRoute() {
    // TODO: implement popRoute
    final navigatorState = navigatorKey.currentState;

    if (navigatorState != null && navigatorState.canPop()) {
      // Use the pop method to pop the route
      navigatorState.pop();
      return Future.value(
          true); // Indicate that the route was popped successfully
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    print("Router Delegate: build called ${routeConfig.route}");
    // if (activePage == null) {
    this.activePage = this.routeConfig.getPage(this);
    // }
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
    return AppRoutePath(this.routeConfig);
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    // TODO: implement setNewRoutePath
    print("Set new route path ${configuration.routeConfig.route}");
    //set the incoming route to reflect the incoming route
    this.routeConfig = configuration.routeConfig;
    this.urlString = configuration.routeConfig.route;
    notifyListeners();
    return;
  }
}

class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    RouteConfig routeConfig = NavigationUtil.resolveRouteToWidget(
        routeInformation.location!, routerMap);
    AppRoutePath path = AppRoutePath(routeConfig);
    print("Path being set = ${path.routeConfig.route}");
    return path;
  }

  @override
  RouteInformation restoreRouteInformation(AppRoutePath configuration) {
    print("Restoring route information ${configuration.routeConfig.route} ");
    return RouteInformation(location: configuration.routeConfig.route);
  }
}

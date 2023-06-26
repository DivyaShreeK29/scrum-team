import 'package:flutter/material.dart';

class RouteConfig {
  Map<String, String> queryParameters;
  Map<String, String> pathParameters;
  dynamic routeCallBackFunction;
  String route;
  String routeKey;
  bool isUnknownRoute = false;

  RouteConfig(
      {required this.route,
      required this.routeKey,
      this.routeCallBackFunction,
      this.isUnknownRoute = false,
      required this.pathParameters,
      required this.queryParameters});

  Widget getPage(routerDelegate) {
    return this.routeCallBackFunction(
        routerDelegate, this.pathParameters, this.queryParameters);
  }
}

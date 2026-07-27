import 'package:flutter/material.dart';

final class NavigationService {
  static final NavigationService _navigationService =
      NavigationService._internal();
  NavigationService._internal();
  static NavigationService get instance => _navigationService;

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<dynamic> navigateTo(String routeName) =>
      navigatorKey.currentState!.pushNamed(routeName);

  static Future<dynamic> navigateToReplacement(String routeName) =>
      navigatorKey.currentState!.pushReplacementNamed(routeName);

  static Future<dynamic> popAndReplace(String routeName) async {
    return await navigatorKey.currentState!.popAndPushNamed(routeName);
  }

  static Future<dynamic> navigateToUntilReplacement(String routeName) =>
      navigatorKey.currentState!
          .pushNamedAndRemoveUntil(routeName, (route) => false);

  static Future<dynamic> navigateToWithArgs(
    String routeName,
    Object? args,
  ) =>
      navigatorKey.currentState!.pushNamed(routeName, arguments: args);

  static Future<dynamic> popAndReplaceWihArgs(
          String routeName, Object? args) =>
      navigatorKey.currentState!.popAndPushNamed(routeName, arguments: args);

  static Future<dynamic> navigateToWithObject(
    String routeName,
    Object? obj,
  ) =>
      navigatorKey.currentState!.pushNamed(routeName, arguments: obj);

  static get goBack => navigatorKey.currentState!.pop();

  static get goBeBack => navigatorKey.currentState!.canPop();

  static get context => navigatorKey.currentContext;

  static void goBackCall() {
    navigatorKey.currentState?.pop();
  }
}

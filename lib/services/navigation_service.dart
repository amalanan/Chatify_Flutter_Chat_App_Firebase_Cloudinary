import 'package:flutter/material.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


  void navigateToRoute(String route) {
    navigatorKey.currentState?.pushNamed(route);
  }

  void navigateAndClear(String route) {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      route,
          (route) => false,
    );
  }


  void navigateToPage(Widget _page) {
    navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) {
          return _page;
        },
      ),
    );
  }

  void goBack() {
    navigatorKey.currentState!.pop();
  }
}

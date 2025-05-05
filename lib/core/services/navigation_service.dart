import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class NavigationService extends GetxService {
  final GoRouter router;

  NavigationService(this.router);

  // Navigate to a named route
  void goToNamed(String routeName, {Object? extra}) {
    router.goNamed(routeName, extra: extra);
  }

  // Push a named route (add to the navigation stack)
  void pushNamed(String routeName, {Object? extra}) {
    router.pushNamed(routeName, extra: extra);
  }

  // Replace the current route with a named route
  void replaceNamed(String routeName, {Object? extra}) {
    router.replaceNamed(routeName, extra: extra);
  }

  // Go back to the previous route
  void goBack() {
    router.pop();
  }

  // Navigate to the initial route (home or splash screen)
  void goToInitialRoute() {
    router.go('/');
  }

  // Get the current route name
  String getCurrentRouteName() {
    return router.routerDelegate.currentConfiguration.last.matchedLocation;
  }
}

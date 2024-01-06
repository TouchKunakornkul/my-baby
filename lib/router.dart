import 'package:flutter/material.dart';
import 'package:my_baby/providers/growth_provider.dart';
import 'package:my_baby/screens/home/home_screen.dart';
import 'package:my_baby/screens/splash_screen.dart';
import 'package:my_baby/widgets/custom_material_page_route.dart';
import 'package:provider/provider.dart';

const String splashRoute = '/';
const String loginRoute = '/login';
const String homeRoute = '/home';

class OpdRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Widget page = getPage(settings.name, settings.arguments);
    return CustomMaterialPageRoute(
        builder: (_) => page,
        settings: _getRouteSetting(settings),
        transitionBuilder:
            _getTransitionBuilder(settings.name, settings.arguments));
  }

  static Future<void> navigateUserToLandingPage(
    BuildContext context, {
    bool fallbackToLogin = false,
  }) async {
    // final Profile? profile = context.read<AuthProvider>().profile;
    // if (profile != null) {
    //   Navigator.pushReplacementNamed(context, homeRoute);
    //   return;
    // }
    // if (fallbackToLogin) {
    // Login Route
    Navigator.pushReplacementNamed(context, homeRoute);
    // }
  }
}

Widget getPage(String? name, Object? arguments) {
  switch (name) {
    case splashRoute:
      return const SplashScreen();
    case homeRoute:
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<GrowthProvider>(
            create: (_) => GrowthProvider(),
          ),
        ],
        child: const HomeScreen(),
      );
    default:
      return Center(child: Text('No route defined for $name'));
  }
}

/*
 * Update setting name for prevent deeplink launch duplicate screen.
 */
RouteSettings _getRouteSetting(RouteSettings settings) {
  return settings;
}

Widget Function(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
)? _getTransitionBuilder(String? name, Object? arguments) {
  switch (name) {
    default:
      return null;
  }
}

import 'package:go_router/go_router.dart';
import 'package:my_baby/screens/home/home_screen.dart';
import 'package:my_baby/screens/splash_screen.dart';

// GoRouter configuration
final CustomRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);

import 'package:go_router/go_router.dart';
import 'package:my_baby/screens/home/home_screen.dart';
import 'package:my_baby/screens/onboarding_screen.dart';
import 'package:my_baby/screens/setting_screen.dart';
import 'package:my_baby/screens/splash_screen.dart';
import 'package:my_baby/screens/support_screen.dart';

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
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/support',
      builder: (context, state) => const SupportScreen(),
    ),
    GoRoute(
      path: '/setting',
      builder: (context, state) => const SettingScreen(),
    )
  ],
);

import 'package:flutter/material.dart';
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
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const SettingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Change the opacity of the screen using a Curve based on the the animation's
            // value
            return SlideTransition(
                position: animation.drive(
                  Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).chain(CurveTween(curve: Curves.easeIn)),
                ),
                child: child);
          },
        );
      },
    ),
  ],
);

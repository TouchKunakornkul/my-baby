import 'package:flutter/material.dart';

class CustomMaterialPageRoute extends MaterialPageRoute {
  Widget Function(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  )? transitionBuilder;

  @override
  @protected
  bool get hasScopedWillPopCallback {
    return false;
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return transitionBuilder?.call(
          context,
          animation,
          secondaryAnimation,
          child,
        ) ??
        super.buildTransitions(
          context,
          animation,
          secondaryAnimation,
          child,
        );
  }

  CustomMaterialPageRoute(
      {required WidgetBuilder builder,
      required RouteSettings settings,
      bool maintainState = true,
      bool fullscreenDialog = false,
      this.transitionBuilder
      // bool? disableTransition = false,
      })
      : super(
          builder: builder,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        );
}

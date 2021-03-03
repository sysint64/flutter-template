import 'package:flutter/widgets.dart';

class FadeRoute extends PageRouteBuilder {
  FadeRoute({
    @required Widget Function(BuildContext) builder,
    RouteSettings settings,
  }) : super(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        );
}

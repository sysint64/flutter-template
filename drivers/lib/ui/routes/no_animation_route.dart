import 'package:flutter/widgets.dart';

class NoAnimationRoute extends PageRouteBuilder {
  NoAnimationRoute({
    @required Widget Function(BuildContext) builder,
    RouteSettings settings,
  }) : super(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionDuration: const Duration(microseconds: 0),
        );
}
